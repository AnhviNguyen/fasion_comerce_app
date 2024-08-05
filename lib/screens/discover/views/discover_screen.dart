import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/api/categoryApi.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/components/skleton/others/discover_categories_skelton.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/search/views/components/search_form.dart';
import 'package:shop/screens/search/views/components/search_provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<Category> categoryModel = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myCate();
  }

  Future<void> myCate() async {
    try {
      final categories = await fetchCategory();
      setState(() {
        categoryModel = categories.take(3).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => SearchProvider(),
          builder: (context, child) {
            final searchProvider = Provider.of<SearchProvider>(context);
            void handleSearch(String query) {
              searchProvider.search(query);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: SearchForm(
                    onSearch: handleSearch,
                    controller: _searchController,
                  ),
                ),
                Expanded(
                  child: searchProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : searchProvider.errorMessage.isNotEmpty
                          ? Center(child: Text(searchProvider.errorMessage))
                          : searchProvider.searchResults.isNotEmpty
                              ? ListView.builder(
                                  itemCount:
                                      searchProvider.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        searchProvider.searchResults[index];
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          product.imagePath,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              Icon(Icons.image_not_supported,
                                                  size: 60),
                                        ),
                                      ),
                                      title: Text(
                                        product.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product.productDescription,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.star,
                                                  size: 16,
                                                  color: Colors.amber),
                                              Text(
                                                  '\$${product.price.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              if (product.salePrice > 0)
                                                Text(
                                                  ' \$${product.salePrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, productDetailsScreenRoute,
                                            arguments: product);
                                      },
                                    );
                                  },
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: defaultPadding / 2,
                                      ),
                                      child: Text(
                                        "Categories",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                    Expanded(
                                      child: isLoading
                                          ? const DiscoverCategoriesSkelton()
                                          : ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: defaultPadding,
                                              ),
                                              itemCount: categoryModel.length,
                                              itemBuilder: (context, index) =>
                                                  CategoriesCard(
                                                    svgSrc: categoryModel[index]
                                                        .imagePath!,
                                                    title: categoryModel[index]
                                                        .name,
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          productByCategoriesScreenRoute,
                                                          arguments:
                                                              categoryModel[
                                                                  index]);
                                                    },
                                                  )),
                                    ),
                                  ],
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final VoidCallback onTap;

  const CategoriesCard({
    Key? key,
    required this.svgSrc,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 30,
          height: 30,
          child: NetworkImageWithLoader(
            svgSrc,
            radius: defaultBorderRadious,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
