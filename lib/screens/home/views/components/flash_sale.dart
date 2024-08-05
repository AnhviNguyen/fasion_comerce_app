import 'package:flutter/material.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({super.key,});
  
  @override
  State<FlashSale> createState() => _FlashSale();
}

class _FlashSale extends State<FlashSale> {
    List<Product> popularProducts = [];
  bool isLoading = true;
  myPopularProduct() {
    fetchProductPopular().then((value) {
      setState(() {
        popularProducts = value;
        print(popularProducts);
      });
    });
  }

  @override
  void initState() {
    myPopularProduct();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find popularProducts on models/ProductModel.dart
            itemCount: popularProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == popularProducts.length - 1
                    ? defaultPadding
                    : 0,
              ),
              child: ProductCard(
                image: popularProducts[index].imagePath,
                brandName: popularProducts[index].brandName,
                title: popularProducts[index].name,
                price: popularProducts[index].price,
                priceAfetDiscount:
                    popularProducts[index].salePrice,
                dicountpercent: popularProducts[index].discount,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: popularProducts[index]);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
