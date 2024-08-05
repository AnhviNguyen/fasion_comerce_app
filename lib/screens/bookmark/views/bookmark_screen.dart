import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/api/cartApi.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreen();
}

class _BookmarkScreen extends State<BookmarkScreen> {
  String userId = '';
  List<Cart> productCart = [];
  bool isLoading = true;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? 'User';
    });
  }

  void myBookmark() {
    if (userId.isEmpty) {
      print("userId is empty");
      return;
    }
    setState(() {
      isLoading = true;
    });
    fetchBookmark(userId).then((value) {
      setState(() {
        print('id user: ' + userId);
        productCart = value;
        print('product cart: ' + productCart.toString());
        isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching cart: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    myBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: defaultPadding,
                      crossAxisSpacing: defaultPadding,
                      childAspectRatio: 0.66,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Stack(
                          children: [
                            ProductCard(
                              image: productCart[index].product.imagePath,
                              brandName: productCart[index].product.brandName,
                              title: productCart[index].product.name,
                              price: productCart[index].product.price,
                              priceAfetDiscount:
                                  productCart[index].product.salePrice,
                              dicountpercent:
                                  productCart[index].product.discount,
                              press: () {
                                Navigator.pushNamed(
                                    context, productDetailsScreenRoute,
                                    arguments: productCart[index].product);
                              },
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: InkWell(
                                onTap: () async {
                                  bool success = await deleteBookmark(userId, productCart[index].product.id);
                                  if (success) {
                                    setState(() {
                                      productCart.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Product removed from bookmark'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Cannot remove product from cart'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: productCart.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
