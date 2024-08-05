import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class OrderSummary extends StatefulWidget {
  final String headerTitle;
  final String subtotal;
  final String discount;
  final String total;
  final String estimatedVat;

  OrderSummary({
    required this.headerTitle,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.estimatedVat,
  });

  @override
  State<OrderSummary> createState() => _OrderSummary();
}

class _OrderSummary extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15), // Padding around the entire content
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2), // Border around the container
        borderRadius: BorderRadius.circular(8), // Optional: rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.headerTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text(widget.subtotal, style: TextStyle(color: Colors.black)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping Fee'),
              Text('Free', style: TextStyle(color: Colors.green)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount'),
              Text(widget.discount, style: TextStyle(color: Colors.black)),
            ],
          ),
          Divider(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total (Include of VAT)',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              Text(widget.total, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estimated VAT'),
              Text(widget.estimatedVat, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
