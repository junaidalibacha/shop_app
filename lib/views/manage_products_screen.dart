import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/views/edit_products_screen.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/user_product_widget.dart';

class ManageProdScreen extends StatelessWidget {
  const ManageProdScreen({Key? key}) : super(key: key);
  static const routeName = '/manageProductsScreen';

  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: prodData.items.length,
        itemBuilder: (ctx, i) => Column(
          children: [
            UserProdWidget(
              prodId: prodData.items[i].id,
              prodImg: prodData.items[i].imgUrl,
              prodTitle: prodData.items[i].title,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
