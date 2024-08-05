import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/api/categoryApi.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/route/screen_export.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../constants.dart';

class CategoriesBarInHome extends StatefulWidget {
  const CategoriesBarInHome({super.key});

  @override
  State<CategoriesBarInHome> createState() => _CategoriesBarInHome();
}

class _CategoriesBarInHome extends State<CategoriesBarInHome> {
  List<Category> categoryModel = [];
  bool isLoading = true;
  myCate() {
    fetchCategory().then((value) {
      isLoading = false;
      setState(() {
        categoryModel = value;
        print(categoryModel);
      });
    });
  }

  @override
  void initState() {
    myCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            categoryModel.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? defaultPadding : defaultPadding / 2,
                  right:
                      index == categoryModel.length - 1 ? defaultPadding : 0),
              child: CategoryBtn(
                category: categoryModel[index].name,
                svgSrc: categoryModel[index].imagePath,
                isActive: index == 0,
                press: () {
                  Navigator.pushNamed(context, productByCategoriesScreenRoute, arguments: categoryModel[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              // SvgPicture.asset(
              //   svgSrc!,
              //   height: 20,
              //   colorFilter: ColorFilter.mode(
              //     isActive ? Colors.white : Theme.of(context).iconTheme.color!,
              //     BlendMode.srcIn,
              //   ),
              // ),
              CachedNetworkImage(
                imageUrl: svgSrc.toString(), 
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                    ),
                  ));
                },
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
