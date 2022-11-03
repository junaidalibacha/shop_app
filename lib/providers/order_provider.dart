import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart_provider.dart';

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
  final List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double price) {
    _orders.insert(
      0,
      OrderItemModel(
        id: DateTime.now().toString(),
        amount: price,
        orderItems: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
