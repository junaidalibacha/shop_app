import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/views/edit_products_screen.dart';

class UserProdWidget extends StatelessWidget {
  const UserProdWidget({
    Key? key,
    required this.prodImg,
    required this.prodTitle,
    required this.prodId,
  }) : super(key: key);
  final String prodId;
  final String prodImg;
  final String prodTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(prodImg),
      ),
      title: Text(prodTitle),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: prodId);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .removeProduct(prodId);
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
