import 'package:flutter/material.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

class ProductByCategoryScreen extends StatefulWidget {
  const ProductByCategoryScreen({super.key, required this.category});

  final Category category;

  @override
  State<ProductByCategoryScreen> createState() => _ProductByCategoryScreen();
}

class _ProductByCategoryScreen extends State<ProductByCategoryScreen> {
  List<Product> productsByCate = [];
  bool isLoading = true;

 Future<void> myProductByCate() async {
    try {
      final products = await fetchProductByCate(widget.category.id);
      setState(() {
        productsByCate = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Optionally, show an error message here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  @override
  void initState() {
    myProductByCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.category.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              // Handle cart action
            },
          ),
        ],
      ),
      body:isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsByCate.isEmpty
          ? const Center(child: Text('No products found'))
          : GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: productsByCate.length, // Number of products
        itemBuilder: (context, index) {
          return ProductCard(
            image: productsByCate[index].imagePath,
            brandName: productsByCate[index].brandName,
            title: productsByCate[index].name,
            price: productsByCate[index].price,
            priceAfetDiscount: productsByCate[index].salePrice,
            dicountpercent: productsByCate[index].discount,
            press: () {
              Navigator.pushNamed(context, productDetailsScreenRoute,
                  arguments: productsByCate[index]);
            },
          );
        },
      ),
    );
  }
}

