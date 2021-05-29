import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var _isinit = false;
  Map<String, Object> _editedProduct = {
    "id": "",
    "description": "",
    "imageUrl": "",
    "price": 0,
    "title": "",
    "isFavourite": false,
  };
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

  @override
  void didChangeDependencies() {
    if (!_isinit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId.length == 0) return;
      final Products product = Provider.of<Products>(context);
      final Product currentProduct = product.findById(productId);
      _editedProduct['id'] = currentProduct.id;
      _editedProduct['description'] = currentProduct.description;
      _editedProduct['imageUrl'] = currentProduct.imageUrl;
      _editedProduct['price'] = currentProduct.price;
      _editedProduct['title'] = currentProduct.title;
      _editedProduct['isFavourite'] = currentProduct.isFavourite;
      _imageUrlController.text = _editedProduct['imageUrl'].toString();
    }
    _isinit = true;
    super.didChangeDependencies();
  }

  void _handleImageUrlChange() {
    setState(() {});
  }

  void _saveForm() {
    final validForm = _formKey.currentState?.validate();
    if (validForm == null || !validForm) return;

    _formKey.currentState?.save();

    Product newProduct = new Product(
      id: _editedProduct['id'].toString(),
      description: _editedProduct['description'].toString(),
      imageUrl: _editedProduct['imageUrl'].toString(),
      price: double.parse(_editedProduct['price'].toString()),
      title: _editedProduct['title'].toString(),
      isFavourite: _editedProduct['isFavourite'] as bool,
    );

    Products product = Provider.of<Products>(context, listen: false);

    if (_editedProduct['id'].toString().length == 0)
      product.addProduct(newProduct);
    else
      product.editProduct(_editedProduct['id'], newProduct);
    Navigator.of(context).pop();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) return "This field can't be empty";
    return null;
  }

  void handleSave(String name, String value) {
    _editedProduct[name] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
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
                initialValue: _editedProduct['title'].toString(),
                onSaved: (value) => handleSave('title', value.toString()),
                validator: validator,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                initialValue: _editedProduct['price'].toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value) => handleSave('price', value.toString()),
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
                initialValue: _editedProduct['description'].toString(),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (value) => handleSave('description', value.toString()),
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
                        _saveForm();
                      },
                      validator: validator,
                      onSaved: (value) =>
                          handleSave('imageUrl', value.toString()),
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
