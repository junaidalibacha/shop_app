import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/views/cart_screen.dart';
import 'package:shop_app/widgets/badge_widget.dart';
import 'package:shop_app/widgets/drawer_widget.dart';

import '../providers/cart_provider.dart';
import '../widgets/product_grid_widget.dart';

enum FilterOption { favorites, all }

class ProductOverViewScreen extends StatefulWidget {
  const ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool _showFavOnly = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   // Provider.of<ProductProvider>(context, listen: false).fetchAndSetProducts();
  //   Future.delayed(Duration.zero).then(
  //     (value) => Provider.of<ProductProvider>(context).fetchAndSetProducts(),
  //   );
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProducts().then(
        (_) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.favorites) {
                  // productsData.showFavOnly();
                  _showFavOnly = true;
                } else {
                  _showFavOnly = false;
                  // productsData.showAll();
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.favorites,
                child: Text(
                  'Only Favorites',
                ),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text(
                  'Show All',
                ),
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (_, cart, ch) => BadgeWidget(
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavOnly: _showFavOnly),
    );
  }
}
