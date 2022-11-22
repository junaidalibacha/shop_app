import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_model.dart';
import 'package:shop_app/providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);
  static const routeName = '/addProductScreen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // final _priceFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editProduct = ProductModel(
    id: '',
    title: '',
    description: '',
    price: 0,
    imgUrl: '',
  );

  var _isLoading = false;

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if ((!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https')) ||
          (!_imgUrlController.text.endsWith('.png') &&
              !_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(_editProduct);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Accured'),
          content: const Text('Some thing went wrong'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;

        print('======> isLoading = False');
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // _priceFocusNode.dispose();

    _imgUrlController.dispose();
    _imgUrlFocusNode.dispose();
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      // initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (value) =>
                      //     FocusScope.of(context)..requestFocus(_priceFocusNode),
                      onSaved: (newValue) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: newValue!,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['price'],

                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // focusNode: _priceFocusNode,
                      onSaved: (newValue) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: _editProduct.description,
                          price: double.parse(newValue!),
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        } else if (double.tryParse(value) == null ||
                            value.isEmpty) {
                          return 'Please enter a valid number';
                        } else if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      // initialValue: _initValues['description'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Discription',
                      ),
                      // textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      // focusNode: _priceFocusNode,
                      onSaved: (newValue) {
                        _editProduct = ProductModel(
                          id: _editProduct.id,
                          title: _editProduct.title,
                          description: newValue!,
                          price: _editProduct.price,
                          imgUrl: _editProduct.imgUrl,
                          isFavorite: _editProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a discription';
                        } else if (value.length < 10) {
                          return 'Discription should be at least 10 characters long.';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: _imgUrlController.text.isEmpty
                              ? const Text('Image URL')
                              : Image.network(
                                  _imgUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imgUrlController,
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imgUrlFocusNode,
                            onSaved: (newValue) {
                              _editProduct = ProductModel(
                                id: _editProduct.id,
                                title: _editProduct.title,
                                description: _editProduct.description,
                                price: _editProduct.price,
                                imgUrl: newValue!,
                                isFavorite: _editProduct.isFavorite,
                              );
                            },
                            onFieldSubmitted: (value) => _saveForm(),
                            validator: (value) {
                              if (!value!.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid Image URL';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
