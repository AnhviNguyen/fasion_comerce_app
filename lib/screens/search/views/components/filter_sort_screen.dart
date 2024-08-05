import 'package:flutter/material.dart';
import 'package:shop/api/productsApi.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

class FilterSortScreen extends StatefulWidget {
  @override
  _FilterSortScreenState createState() => _FilterSortScreenState();
}

class _FilterSortScreenState extends State<FilterSortScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSizeExpanded = false;
  bool _isPriceExpanded = false;

  List<Map<String, bool>> _sizes = [
    {'XS': false},
    {'S': false},
    {'M': false},
    {'L': false},
    {'XL': false},
  ];

  List<Map<String, bool>> _prices = [
    {'Under \$25': false},
    {'\$25 - \$50': false},
    {'\$50 - \$100': false},
    {'\$100 - \$300': false},
    {'Over \$300': false},
  ];

  Map<String, bool> _sortOptions = {
    'Price [Low to High]': false,
    'Price [High to Low]': false,
    'Highest Rated': false,
    'A-Z': false,
    'Z-A': false,
  };

  String _selectedSize = '';
  String _selectedPriceRange = '';
  String _selectedSort = '';

  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyFilters() async {
    setState(() {
      _isLoading = true;
    });

    String size = _sizes
        .firstWhere((size) => size.values.first, orElse: () => {'': false})
        .keys
        .first;
    String priceRange = _prices
        .firstWhere((price) => price.values.first, orElse: () => {'': false})
        .keys
        .first;
    String sort = _sortOptions.keys.firstWhere(
        (option) => _sortOptions[option] ?? false,
        orElse: () => '');

    // Convert price range to API format
    String apiPriceRange = '';
    if (priceRange == 'Under \$25') {
      apiPriceRange = '0-25';
    } else if (priceRange == '\$25 - \$50') {
      apiPriceRange = '25-50';
    } else if (priceRange == '\$50 - \$100') {
      apiPriceRange = '50-100';
    } else if (priceRange == '\$100 - \$300') {
      apiPriceRange = '100-300';
    } else if (priceRange == 'Over \$300') {
      apiPriceRange = '300-999999';
    }

    // Convert sort option to API format
    String apiSort = '';
    if (sort == 'Price [Low to High]') {
      apiSort = 'priceLowToHigh';
    } else if (sort == 'Price [High to Low]') {
      apiSort = 'priceHighToLow';
    } else if (sort == 'Highest Rated') {
      apiSort = 'rating';
    }

    try {
      var result = await fetchProductByFilter(size, apiPriceRange, apiSort);
      setState(() {
        _filteredProducts = result;
        _isLoading = false;
      });
      _showFilteredProducts();
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFilteredProducts() {
    customModalBottomSheet(
      context,
      isDismissible: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Filtered Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return cardResultProductFilter(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Filter & Sort', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            child: Text('Clear All', style: TextStyle(color: primaryColor)),
            onPressed: () {
              setState(() {
                _sizes.forEach(
                    (size) => size.update(size.keys.first, (v) => false));
                _prices.forEach(
                    (price) => price.update(price.keys.first, (v) => false));
                _sortOptions.updateAll((key, value) => false);
                _selectedSize = '';
                _selectedPriceRange = '';
                _selectedSort = '';
                _filteredProducts = [];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Filter'),
                Tab(text: 'Sort'),
              ],
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Filter Tab
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Size
                            ListTile(
                              title: Text('Size'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                setState(() {
                                  _isSizeExpanded = !_isSizeExpanded;
                                });
                              },
                            ),
                            if (_isSizeExpanded)
                              ..._sizes.map((size) {
                                String sizeKey = size.keys.first;
                                return ListTile(
                                  title: Text(sizeKey),
                                  textColor: Colors.grey,
                                  trailing: Checkbox(
                                    value: size[sizeKey],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        size[sizeKey] = value ?? false;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            // Price
                            ListTile(
                              title: Text('Price'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                setState(() {
                                  _isPriceExpanded = !_isPriceExpanded;
                                });
                              },
                            ),
                            if (_isPriceExpanded)
                              ..._prices.map((price) {
                                String priceKey = price.keys.first;
                                return ListTile(
                                  title: Text(priceKey),
                                  textColor: Colors.grey,
                                  trailing: Checkbox(
                                    value: price[priceKey],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        price[priceKey] = value ?? false;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Sort Tab
                SingleChildScrollView(
                  child: Column(
                    children: _sortOptions.keys.map((option) {
                      return CheckboxListTile(
                        title: Text(option),
                        value: _sortOptions[option],
                        onChanged: (bool? value) {
                          setState(() {
                            _sortOptions.updateAll((key, value) => false);
                            _sortOptions[option] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Add Apply Filters Button here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('Apply Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _applyFilters,
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget cardResultProductFilter(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(
          _filteredProducts[index].imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(_filteredProducts[index].name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${_filteredProducts[index].price.toStringAsFixed(2)}'),
            Text('Brand: ${_filteredProducts[index].brandName}'),
          ],
        ),
        trailing: Text(
            '${_filteredProducts[index].discount.toStringAsFixed(0)}% OFF'),
        onTap: () { Navigator.pushNamed(context, productDetailsScreenRoute,
                      arguments: _filteredProducts[index]);},
      ),
    );
  }
}
