import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/api/cartApi.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_model.dart';
import 'package:shop/screens/checkout/component/cart_item.dart';
import 'package:shop/screens/checkout/component/order_sumary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String userId = '';
  List<Cart> productCart = [];
  bool isLoading = true;
  double subtotal = 0;
  double discount = 0;
  double total = 0;
  double estimatedVat = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await myCart();
    calculateOrderSummary();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> myCart() async {
    if (userId.isEmpty) {
      print("userId is empty");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      List<Cart> cartItems = await fetchCart(userId);
      setState(() {
        productCart = cartItems;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching cart: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateQuantity(int index, int newQuantity, String productId) {
    if (newQuantity > 0) {
      setState(() {
        productCart[index].quantity = newQuantity;
      });
      updateCart(userId, productId, newQuantity);
      calculateOrderSummary();
    }
  }

  void calculateOrderSummary() {
    subtotal = productCart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    // Assume discount is 0 for now, you can update this logic as needed
    discount = productCart.fold(0, (sum, item) => sum + ((item.product.price-item.product.salePrice )* item.quantity));;
    total = subtotal - discount;
    estimatedVat = total * 0.1; // Assume 10% VAT, adjust as needed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Review your order',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (productCart.isEmpty)
                    Center(child: Text('Your cart is empty'))
                  else
                    ...productCart.asMap().entries.map((entry) {
                      int index = entry.key;
                      Cart cartItem = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: CartItem(
                          brand: cartItem.product.brandName,
                          name: cartItem.product.name,
                          price: cartItem.product.salePrice,
                          originalPrice: cartItem.product.price,
                          imageUrl: cartItem.product.imagePath,
                          quantity: cartItem.quantity,
                          onDecrement: () =>
                              updateQuantity(index, cartItem.quantity - 1, cartItem.product.id),
                          onIncrement: () =>
                              updateQuantity(index, cartItem.quantity + 1, cartItem.product.id),
                          onDelete: () {
                            deleteCart(userId, cartItem.product.id);
                            setState(() {
                              productCart.removeAt(index);
                            });
                            calculateOrderSummary();
                          },
                        ),
                      );
                    }).toList(),
                  SizedBox(height: 24),
                  Text(
                    'Your Coupon code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Type coupon code',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          "assets/icons/Coupon.svg",
                          height: 20,
                          width: 20,
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      isDense: true,
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  OrderSummary(
                    headerTitle: 'Order Summary',
                    subtotal: '\$${subtotal.toStringAsFixed(2)}',
                    discount: '-\$${discount.toStringAsFixed(2)}',
                    total: '\$${total.toStringAsFixed(2)}',
                    estimatedVat: '\$${estimatedVat.toStringAsFixed(2)}',
                  ),
                ]),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Continue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: Implement continue functionality
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}