import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/views/add_product_screen.dart';
import 'package:shop_app/views/cart_screen.dart';
import 'package:shop_app/views/edit_products_screen.dart';
import 'package:shop_app/views/manage_products_screen.dart';
import 'package:shop_app/views/orders_screen.dart';
import 'package:shop_app/views/product_details_screen.dart';
import 'package:shop_app/views/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        home: const ProductOverViewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          ManageProdScreen.routeName: (ctx) => const ManageProdScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          AddProductScreen.routeName: (ctx) => const AddProductScreen(),
        },
      ),
    );
  }
}
