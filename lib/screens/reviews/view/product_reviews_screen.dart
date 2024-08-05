import 'package:flutter/material.dart';
import 'package:shop/api/reviewApi.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/review_model.dart';
import 'package:shop/route/screen_export.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreen();
}

class _ProductReviewsScreen extends State<ProductReviewsScreen> {
  List<Review> reviews = [];
  bool isLoading = true;
  String _selectedSortOption = 'Most useful';

  @override
  void initState() {
    super.initState();
    myReview();
  }

  void myReview() {
    setState(() {
      isLoading = true;
    });
    fetchReview(widget.product.id).then((value) {
      setState(() {
        print('id product: ' + widget.product.id);
        reviews = value;
        print('review' + reviews.toString());
        isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching reviews: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  Map<int, int> calculateRatingCounts(List<Review> reviews) {
    Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews) {
      int rating = review.rating;
      if (ratingCounts.containsKey(rating)) {
        ratingCounts[rating] = ratingCounts[rating]! + 1;
      }
    }

    return ratingCounts;
  }

  Map<int, double> calculateRatingPercentages(
      Map<int, int> ratingCounts, int totalReviews) {
    Map<int, double> ratingPercentages = {};

    ratingCounts.forEach((rating, count) {
      ratingPercentages[rating] = totalReviews > 0 ? count / totalReviews : 0.0;
    });

    return ratingPercentages;
  }

  Future<void> _navigateAndRefresh() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddReviewScreen(product: widget.product),
      ),
    );

    if (result == true) {
      // Result indicates that the review was submitted successfully
      myReview(); // Refresh reviews
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Review> sortedReviews = _sortReviews(reviews, _selectedSortOption);

    Map<int, double> ratingPercentages = reviews.isNotEmpty
        ? calculateRatingPercentages(
            calculateRatingCounts(reviews),
            reviews.length,
          )
        : {};

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text('Reviews', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildReviewSummary(ratingPercentages),
                _buildAddReviewButton(),
                _buildSortDropdown(),
                _buildUserReviews(sortedReviews),
              ],
            ),
    );
  }

  Widget _buildReviewSummary(Map<int, double> ratingPercentages) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            _calculateAverageRating(reviews).toStringAsFixed(1),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text('/5', style: TextStyle(fontSize: 24, color: Colors.grey)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRatingBar(
                    '5 Star', ratingPercentages[5] ?? 0.0, warningColor),
                _buildRatingBar(
                    '4 Star', ratingPercentages[4] ?? 0.0, warningColor),
                _buildRatingBar(
                    '3 Star', ratingPercentages[3] ?? 0.0, warningColor),
                _buildRatingBar(
                    '2 Star', ratingPercentages[2] ?? 0.0, warningColor),
                _buildRatingBar(
                    '1 Star', ratingPercentages[1] ?? 0.0, warningColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating =
        reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }

  Widget _buildRatingBar(String label, double percentage, Color color) {
    return Row(
      children: [
        Text(label),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 8,
            color: Colors.grey[300],
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddReviewButton() {
    return ListTile(
      leading: Icon(Icons.add_circle_outline),
      title: Text('Add Review'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        _navigateAndRefresh();
      },
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('User reviews'),
          DropdownButton<String>(
            value: _selectedSortOption,
            items: ['Most useful', 'Newest', 'Highest rating', 'Lowest rating']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedSortOption = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviews(List<Review> sortedReviews) {
    return Column(
      children: sortedReviews
          .map((review) => _buildUserReview(
                review.user.username,
                _formatTimeAgo(review.timestamp),
                review.rating,
                review.comment,
              ))
          .toList(),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    // Implement a function to format time ago
    Duration difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildUserReview(
      String name, String time, int rating, String comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red,
        child: Text(name[0], style: TextStyle(color: Colors.white)),
      ),
      title: Row(
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: warningColor,
                size: 16,
              );
            }),
          ),
          SizedBox(height: 4),
          Text(
            comment,
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  List<Review> _sortReviews(List<Review> reviews, String sortOption) {
    List<Review> sortedReviews = List.from(reviews);

    switch (sortOption) {
      case 'Newest':
        sortedReviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case 'Highest rating':
        sortedReviews.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Lowest rating':
        sortedReviews.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'Most useful':
      default:
        // Giữ nguyên thứ tự hiện tại hoặc thêm logic sắp xếp "Most useful" nếu có
        break;
    }

    return sortedReviews;
  }
}
