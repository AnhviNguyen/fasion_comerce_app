import 'package:flutter/material.dart';
import 'package:shop/screens/product/views/components/product_quantity.dart';

class CartItem extends StatelessWidget {
  final String brand;
  final String name;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  CartItem({
    required this.brand,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(brand, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 7),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 7),
                Row(
                  children: [
                    Text('\$${price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    SizedBox(width: 7),
                    if (originalPrice != null)
                      Text('\$${originalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          ProductQuantity(
            numOfItem: quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ],
      ),
    );
  }
}