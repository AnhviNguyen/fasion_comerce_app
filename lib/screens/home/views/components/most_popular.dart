import 'package:flutter/material.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/models/product_model.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class MostPopular extends StatefulWidget {
  const MostPopular({super.key,});

  @override
  State<MostPopular> createState() => _MostPopular();
}

class _MostPopular extends State<MostPopular> {
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
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Most popular",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // SeconderyProductsSkelton(),
        SizedBox(
          height: 114,
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
              child: SecondaryProductCard(
                image: popularProducts[index].imagePath,
                brandName: popularProducts[index].brandName,
                title: popularProducts[index].name,
                price: popularProducts[index].price,
                priceAfetDiscount: popularProducts[index].salePrice,
                dicountpercent: popularProducts[index].discount,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: popularProducts[index]);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
