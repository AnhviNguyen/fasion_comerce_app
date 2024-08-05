import 'package:flutter/material.dart';
import 'package:shop/api/voucherApi.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/voucher_model.dart';
import '../../../constants.dart';

class ShippingInfo extends StatefulWidget {
  const ShippingInfo({Key? key, required this.product}) : super(key: key);

  final Product product;
  
  @override
  State<ShippingInfo> createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  List<Voucher> vouchers = [];
  bool isLoading = true;
  void myVoucher() {
    setState(() {
      isLoading = true;
    });
    fetchVouchers().then((value) {
      setState(() {
        vouchers = value;
        isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching vouchers: $error");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    myVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            _buildHeader(context),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShippingMethods(
                            vouchers
                          ),
                          SizedBox(height: 16),
                          _buildFooterNotes(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40, child: BackButton()),
          Text(
            "Shipping information",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

Widget _buildShippingMethods(List<Voucher> vouchers) {
  // Sắp xếp vouchers
  vouchers.sort((a, b) {
    bool canUseA = widget.product.salePrice < a.conditionPrice;
    bool canUseB = widget.product.salePrice < b.conditionPrice;
    if (canUseA && !canUseB) return -1;
    if (!canUseA && canUseB) return 1;
    return 0;
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: vouchers.map((voucher) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ShippingMethodCard(
          voucher: voucher,
          icon: Icons.check_circle_outline,
          product: widget.product,
        ),
      );
    }).toList(),
  );
}

  Widget _buildFooterNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rush shipping may not be available for all orders depending on fulfillment location.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Shipping outside of the US? See our International shipping rates.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This item is available for delivery to one of our convenient Collection Points.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class ShippingMethodCard extends StatelessWidget {
  final Voucher voucher;
  final IconData icon;
  final Product product;

  const ShippingMethodCard({
    Key? key,
    required this.voucher,
    required this.icon,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool canUseVoucher = product.salePrice < voucher.conditionPrice;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
            title: Row(
              children: [
                Text(voucher.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                if (canUseVoucher)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Available',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            subtitle: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: voucher.detail.formattedDetails(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          if (canUseVoucher)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                "You can use it",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}