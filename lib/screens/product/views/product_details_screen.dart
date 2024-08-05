import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/api/cartApi.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/api/reviewApi.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/review_model.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/product/views/shipping_info.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreen();
}

class _ProductDetailsScreen extends State<ProductDetailsScreen> {
  List<Review> reviews = [];
  List<Product> popularProducts = [];
  bool isLoading = true;
  String userId = '';

  @override
  void initState() {
    super.initState();
    myReview();
    myPopularProduct();
    _loadUserData();
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

  myPopularProduct() {
    fetchProductPopular().then((value) {
      setState(() {
        popularProducts = value;
        print(popularProducts);
      });
    });
  }

  Map<int, int> calculateRatingCounts() {
    Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      if (ratingCounts.containsKey(review.rating)) {
        ratingCounts[review.rating] = (ratingCounts[review.rating] ?? 0) + 1;
      }
    }
    return ratingCounts;
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) return 0;
    double total = reviews.fold(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Product product =
    //     ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      bottomNavigationBar: true
          ? CartButton(
              price: widget.product.salePrice,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductBuyNowScreen(product: widget.product),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    bool success = await addToBookmark(userId, widget.product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Product added to bookmark successfully!' : 'Failed to add product to bookmark.'),
                        duration: Duration(seconds: 2),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
            ProductImages(
              images: widget.product.imagePath is String
                  ? [widget.product.imagePath]
                  : (widget.product.imagePath as List<dynamic>)
                      .map((e) => e.toString())
                      .toList(),
            ),
            ProductInfo(
              brand: widget.product.brandName,
              title: widget.product.name,
              isAvailable: true,
              description: widget.product.productDescription,
              rating: calculateAverageRating(),
              numOfReviews: reviews.length,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: "Product Details",
              press: () {
                customModalBottomSheet(context,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: ProductKit(product: widget.product));
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: "Shipping Information",
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ShippingInfo(
                    product: widget.product,
                  ),
                );
              },
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: "Returns",
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: isLoading
                    ? CircularProgressIndicator()
                    : reviews.isEmpty
                        ? Text("No reviews yet")
                        : ReviewCard(
                            rating: calculateAverageRating(),
                            numOfReviews: reviews.length,
                            numOfFiveStar: calculateRatingCounts()[5] ?? 0,
                            numOfFourStar: calculateRatingCounts()[4] ?? 0,
                            numOfThreeStar: calculateRatingCounts()[3] ?? 0,
                            numOfTwoStar: calculateRatingCounts()[2] ?? 0,
                            numOfOneStar: calculateRatingCounts()[1] ?? 0,
                          ),
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Chat.svg",
              title: "Reviews",
              isShowBottomBorder: true,
              press: () {
                Navigator.pushNamed(context, productReviewsScreenRoute,
                    arguments: widget.product);
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "You may also like",
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = popularProducts[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: defaultPadding,
                          right: index == popularProducts.length - 1
                              ? defaultPadding
                              : 0),
                      child: ProductCard(
                        image: popularProducts[index].imagePath,
                        title: popularProducts[index].name,
                        brandName: product.brandName,
                        price: product.price,
                        priceAfetDiscount: popularProducts[index].salePrice,
                        dicountpercent: popularProducts[index].discount,
                        press: () {
                          Navigator.pushNamed(
                              context, productDetailsScreenRoute,
                              arguments: popularProducts[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
