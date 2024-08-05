import 'package:flutter/material.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({
    super.key,
  });

  @override
  State<PopularProducts> createState() => _PopularProducts();
}

class _PopularProducts extends State<PopularProducts> {
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
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
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
