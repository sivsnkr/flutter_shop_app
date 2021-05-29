import 'package:flutter/material.dart';

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
    price: -1,
    title: "",
    isFavourite: false,
  );
  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // logic goes here
    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
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
                onSaved: (value) {
                  _editedProduct = new Product(
                    id: _editedProduct.id,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    title: value.toString(),
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
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
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
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
                        _saveForm();
                      },
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
