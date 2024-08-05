import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/models/process_product.dart';

class OrderProcessingScreen extends StatefulWidget {
  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreen();
}

class _OrderProcessingScreen extends State<OrderProcessingScreen> {
  List<ProcessProduct> product = [];
  bool isLoading = true;
  String userId = '';

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? 'User';
    });
  }

  void myProduct() {
    setState(() {
      isLoading = true;
    });
    fetchProcessProduct(userId).then((value) {
      setState(() {
        product = value;
        isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching products: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) => myProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Processing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderCard(),
                    StatusTimeline(),
                    SizedBox(height: 16),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : OrderItems(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Removes default shadow
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #FD56398220', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Placed on Jun 10, 2024'),
                Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildStatusDot('Ordered', true, true),
          Expanded(child: _buildDivider()),
          _buildStatusDot('Processing', true, false),
          Expanded(child: _buildDivider()),
          _buildStatusDot('Packed', false, false),
          Expanded(child: _buildDivider()),
          _buildStatusDot('Shipped', false, false),
          Expanded(child: _buildDivider()),
          _buildStatusDot('Delivered', false, false),
        ],
      ),
    );
  }

  Widget _buildStatusDot(String label, bool isActive, bool isCompleted) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey,
            border: Border.all(
              color: isCompleted ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: isCompleted
              ? Icon(Icons.check, color: Colors.white, size: 20)
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      color: Colors.green,
    );
  }
}

class OrderItems extends StatelessWidget {
  final List<ProcessProduct> product;

  OrderItems({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: product.map((item) {
        return OrderItemCard(
          imageUrl: item.imagePath,
          title: item.name,
          price: item.salePrice,
          originalPrice: item.price,
        );
      }).toList(),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double? originalPrice;

  OrderItemCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Removes default shadow
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8), // Rounded corners for image
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
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('\$$price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                      if (originalPrice != null) ...[
                        SizedBox(width: 10),
                        Text(
                          '\$$originalPrice',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
