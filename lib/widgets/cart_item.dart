import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final id;
  final productId;
  final price;
  final quantity;
  final title;
  final Function removeItem;
  CartItem({
    this.productId,
    this.title,
    this.id,
    this.price,
    this.quantity,
    required this.removeItem,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(productId);
      },
      child: Container(
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
      ),
    );
  }
}
