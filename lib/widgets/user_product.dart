import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProduct extends StatelessWidget {
  final String _title;
  final String _imageUrl;
  final String _id;

  UserProduct(this._title, this._imageUrl, this._id);
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(
            _title,
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: _id);
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(_id);
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Something went wrong!'),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
