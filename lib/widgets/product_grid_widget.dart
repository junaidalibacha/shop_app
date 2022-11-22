import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

import 'product_item_widget.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    required this.showFavOnly,
  }) : super(key: key);
  final bool showFavOnly;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products = showFavOnly ? productData.favItems : productData.items;
    for (int i = 0; i < productData.favItems.length; i++) {
      print(products[i].id);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItemWidget(
            // id: products[index].id,
            // title: products[index].title,
            // imgUrl: products[index].description,
            ),
      ),
    );
  }
}
