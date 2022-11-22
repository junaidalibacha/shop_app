import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/views/add_product_screen.dart';
import 'package:shop_app/widgets/drawer_widget.dart';
import 'package:shop_app/widgets/user_product_widget.dart';

class ManageProdScreen extends StatelessWidget {
  const ManageProdScreen({Key? key}) : super(key: key);
  static const routeName = '/manageProductsScreen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final prodData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
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
      ),
    );
  }
}
