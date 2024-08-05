import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop/api/constantLink.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/reviews/view/components/review_product_card.dart';
import 'package:http/http.dart' as http;

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key, required this.product});

  final Product product;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double rating = 0.0;
  bool recommendProduct = false;
  final titleController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Add Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReviewProductInfoCard(
              image: widget.product.imagePath,
              brand: widget.product.brandName,
              title: widget.product.name,
            ),
            const SizedBox(height: 20),
            const Text('Your overall rating of this product'),
            RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: warningColor,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Set a Title for your review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText:
                    'What did you like or dislike?\nWhat should shoppers know before?',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Would you recommend this product?'),
                const Spacer(),
                Switch(
                  value: recommendProduct,
                  onChanged: (bool value) {
                    setState(() {
                      recommendProduct = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                postReview();
              },
            ),
          ],
        ),
      ),
    );
  }

// Add this function in your _AddReviewScreenState class
  Future<void> postReview() async {
    final url = Uri.parse(Constantlink.baseUrl +
        'review/create'); // Replace with your actual endpoint
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': '6ZOa4rwEikz1INO01PUw', // Replace with actual user ID
        'productId': widget.product.id,
        'rating': rating.toInt(),
        'comment': commentController.text,
        'timestamp': DateTime.now().toIso8601String(),
        'title': titleController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Review posted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );
      Navigator.of(context).pop(true); // Go back to previous screen
    } else {
      // Error posting review
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review')),
      );
    }
  }
}
