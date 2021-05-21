import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final id;
  final price;
  final quantity;
  final title;
  CartItem({
    this.title,
    this.id,
    this.price,
    this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('Rs$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'Total: Rs${price * quantity}',
            ),
            trailing: Text(
              '$quantity',
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
    );
  }
}
