import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/models/process_product.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/order/views/process_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State createState() => _OrdersScreen();
}

class _OrdersScreen extends State<OrdersScreen> {
  int delivered = 0;
  int cancel = 0;
  int process = 0;
  String userId = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    if (userId.isNotEmpty) {
      _fetchOrderCounts();
    }
  }

  Future _fetchOrderCounts() async {
    try {
      final deli_arr = await fetchDeliveredProduct(userId);
      final cancel_arr = await fetchCancelProduct(userId);
      final process_arr = await fetchProcessProduct(userId);
      setState(() {
        delivered = deli_arr?.length ?? 0;
        cancel = cancel_arr?.length ?? 0;
        process = process_arr?.length ?? 0;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text(
                  'Orders history',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OrderStatusItem(
                  icon: Icons.hourglass_empty,
                  title: 'Awaiting Payment',
                  count: 0,
                  color: Colors.amber,
                ),
                OrderStatusItem(
                  icon: Icons.sync,
                  title: 'Processing',
                  count: process,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pushNamed(context, processOrderScreenRoute);
                  },
                ),
                OrderStatusItem(
                  icon: Icons.local_shipping,
                  title: 'Delivered',
                  count: delivered,
                  color: Colors.purple,
                ),
                OrderStatusItem(
                  icon: Icons.assignment_return,
                  title: 'Returned',
                  count: 0,
                  color: Colors.deepPurple,
                ),
                OrderStatusItem(
                  icon: Icons.cancel,
                  title: 'Canceled',
                  count: cancel,
                  color: Colors.red,
                ),
              ],
            ),
    );
  }
}

class OrderStatusItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const OrderStatusItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
