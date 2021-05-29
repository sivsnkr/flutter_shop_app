import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = new Product(
    id: "",
    description: "",
    imageUrl: "",
    price: 0,
    title: "",
    isFavourite: false,
  );
  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlController.addListener(_handleImageUrlChange);
    super.initState();
  }

  void _handleImageUrlChange() {
    setState(() {});
  }

  void _saveForm(Products product) {
    final validForm = _formKey.currentState?.validate();
    if (validForm == null || !validForm) return;
    _formKey.currentState?.save();
    if (_editedProduct.id.length == 0)
      product.addProduct(_editedProduct);
    else
      product.editProduct(_editedProduct.id, _editedProduct);
    Navigator.of(context).pop();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) return "This field can't be empty";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final Products product = Provider.of<Products>(context);
    if (productId.length != 0) {
      _editedProduct = product.findById(productId);
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(product),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                initialValue: _editedProduct.title,
                onSaved: (value) {
                  _editedProduct = new Product(
                    id: productId,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    title: value.toString(),
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: validator,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                initialValue: _editedProduct.price.toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _editedProduct = new Product(
                    id: _editedProduct.id,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value.toString()),
                    title: _editedProduct.title,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (value) {
                  final res = validator(value);
                  if (res != null) return res;
                  if (double.tryParse(value == null ? "" : value) == null)
                    return "Please enter a valid price.";
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                initialValue: _editedProduct.description,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) {
                  _editedProduct = new Product(
                    id: _editedProduct.id,
                    description: value.toString(),
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    title: _editedProduct.title,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: validator,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Image.network(
                      _imageUrlController.text.isEmpty
                          ? "https://numpaint.com/wp-content/uploads/2020/08/japan-autumn-season-paint-by-number.jpg"
                          : _imageUrlController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      onFieldSubmitted: (_) {
                        _saveForm(product);
                      },
                      validator: validator,
                      // initialValue: _editedProduct.imageUrl,
                      onSaved: (value) {
                        _editedProduct = new Product(
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: value.toString(),
                          price: _editedProduct.price,
                          title: _editedProduct.title,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
