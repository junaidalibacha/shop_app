import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/ordersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuter;
  Future _obtainOrdersFuture() {
    return Provider.of<OrderProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuter = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const DrawerWidget(),
      // body: _isloading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : ListView.builder(
      //         itemCount: orderData.orders.length,
      //         itemBuilder: (context, index) => OrderItemWidget(
      //           order: orderData.orders[index],
      //         ),
      //       ),
      body: FutureBuilder(
        future: _ordersFuter,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An Error Accured'),
              );
            } else {
              return Consumer<OrderProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) => OrderItemWidget(
                    order: orderData.orders[index],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}



// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({Key? key}) : super(key: key);
//   static const routeName = '/ordersScreen';

// //   @override
// //   State<OrdersScreen> createState() => _OrdersScreenState();
// // }

// // class _OrdersScreenState extends State<OrdersScreen> {
// //   bool _isloading = false;
// //   @override
// //   void initState() {
// //     // Future.delayed(Duration.zero).then((value) async {
// //     _isloading = true;
// //     Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders().then(
// //           (_) => setState(() {
// //             _isloading = false;
// //           }),
// //         );
// //     super.initState();
// //   }

//   @override
//   Widget build(BuildContext context) {
//     // final orderData = Provider.of<OrderProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Orders'),
//       ),
//       drawer: const DrawerWidget(),
//       // body: _isloading
//       //     ? const Center(
//       //         child: CircularProgressIndicator(),
//       //       )
//       //     : ListView.builder(
//       //         itemCount: orderData.orders.length,
//       //         itemBuilder: (context, index) => OrderItemWidget(
//       //           order: orderData.orders[index],
//       //         ),
//       //       ),
//       body: FutureBuilder(
//         future: Provider.of<OrderProvider>(context, listen: false)
//             .fetchAndSetOrders(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             if (snapshot.error != null) {
//               return const Center(
//                 child: Text('An Error Accured'),
//               );
//             } else {
//               return Consumer<OrderProvider>(
//                 builder: (ctx, orderData, child) => ListView.builder(
//                   itemCount: orderData.orders.length,
//                   itemBuilder: (context, index) => OrderItemWidget(
//                     order: orderData.orders[index],
//                   ),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }
