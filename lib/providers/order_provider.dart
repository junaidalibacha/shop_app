import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItemModel {
  final String id;
  final double amount;
  final List<CartItem> orderItems;
  final DateTime dateTime;

  OrderItemModel({
    required this.id,
    required this.amount,
    required this.orderItems,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var url =
        Uri.https('shop-app-4262-default-rtdb.firebaseio.com', 'orders.json');
    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItemModel> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItemModel(
          id: orderId,
          amount: orderData['amount'],
          orderItems: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalPrice) async {
    var url =
        Uri.https('shop-app-4262-default-rtdb.firebaseio.com', 'orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': totalPrice,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItemModel(
        id: json.decode(response.body)['name'],
        amount: totalPrice,
        orderItems: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
