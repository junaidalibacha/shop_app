import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product_model.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<ProductModel> _items = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imgUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imgUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // bool _showFavOnly = false;

  List<ProductModel> get items {
    // if (_showFavOnly) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  List<ProductModel> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  ProductModel findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // void showFavOnly() {
  //   _showFavOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavOnly = false;
  //   notifyListeners();
  // }
  Future<dynamic> fetchAndSetProducts() async {
    // var url = Uri.parse('shop-app-4262-default-rtdb.firebaseio.com');
    var url =
        Uri.https('shop-app-4262-default-rtdb.firebaseio.com', 'products.json');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      // print(response.body);
      // print(json.decode(response.body));
      // if (response.statusCode == 200) {
      //   String data = response.body;
      //   var decodeData = jsonDecode(data);
      //   return decodeData;
      // } else {
      //   return 'Failed';
      // }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductModel> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          ProductModel(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imgUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    var url =
        Uri.https('shop-app-4262-default-rtdb.firebaseio.com', 'products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imgUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = ProductModel(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
    //     .then(
    //   (value) {
    //     final newProduct = ProductModel(
    //       id: json.decode(value.body)['name'],
    //       title: product.title,
    //       description: product.description,
    //       price: product.price,
    //       imgUrl: product.imgUrl,
    //     );
    //     _items.add(newProduct);
    //     // _items.insert(0, newProduct); // at the start of the list
    //     notifyListeners();
    //   },
    // ).catchError(
    //   (error) {
    //     print(error);
    //     throw error;
    //   },
    // );
    // print('data added');
    // final newProduct = ProductModel(
    //   id: DateTime.now().toString(),
    //   title: product.title,
    //   description: product.description,
    //   price: product.price,
    //   imgUrl: product.imgUrl,
    // );
    // _items.add(newProduct);
    // // _items.insert(0, newProduct); // at the start of the list
    // notifyListeners();
  }

  Future<void> updateProduct(String id, ProductModel newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      var url = Uri.https(
          'shop-app-4262-default-rtdb.firebaseio.com', '/products/$id.json');

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imgUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // print('.... ');
    }
  }

  Future<void> removeProduct(String id) async {
    var url = Uri.https(
        'shop-app-4262-default-rtdb.firebaseio.com', '/products/$id.json');
    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    ProductModel? existingProd = _items[existingProdIndex];
    // _items.removeWhere((element) => element.id == id);
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProd = null;
  }
}
