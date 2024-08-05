import 'package:flutter/material.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/product/views/components/selected_colors.dart';
import 'package:shop/screens/product/views/components/selected_size.dart';
import '../../../constants.dart';

class ProductKit extends StatefulWidget {
  const ProductKit({super.key, required this.product});

  final Product product;

  @override
  _ProductKitState createState() => _ProductKitState();
}

class _ProductKitState extends State<ProductKit> {
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = widget.product.colors.map((c) => parseColor(c)).toList();
  }

  Color parseColor(String colorString) {
    final values = colorString.substring(5, colorString.length - 1).split(',');
    final r = int.parse(values[0]);
    final g = int.parse(values[1]);
    final b = int.parse(values[2]);
    final a = (double.parse(values[3]) * 255).round();
    return Color.fromARGB(a, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Details', null),
                  _buildDetailItems(),
                  _buildSection('Style Notes', null),
                  _buildStyleNotes(),
                  const SizedBox(height: 16),
                  SelectedSize(
                      sizes: widget.product.sizes,
                      selectedIndex: selectedSizeIndex,
                      press: (index) {
                        setState(() {
                          selectedSizeIndex = index;
                        });
                      }),
                  const SizedBox(height: 16),
                  SelectedColors(
                    colors: colors,
                    selectedColorIndex: selectedColorIndex,
                    press: (index) {
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                  ),
                ],
              ),
            )
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
          Text("Product detail", style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String? content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(title,
            style: Theme.of(context).textTheme.titleSmall,
           )
          ),
         if (content != null) ...[
          Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(content,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,  // Màu xám cụ thể
            ),
           )
          ),
        ],
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetailItems() {
    final details = [
      'Materials: 100% cotton, and lining Structured',
      'Head circumference: 21" - 24" / 54-62 cm',
    ];
    return Column(
      children: details.map((detail) => _buildDetailItem(detail)).toList(),
    );
  }

  Widget _buildDetailItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

Widget _buildStyleNotes() {
  final styleNotes = [
    {'Style': 'Summer Hat'},
    {'Design': 'Plain'},
    {'Fabric': 'Jersey'},
  ];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: styleNotes
              .map((note) => _buildStyleNote(note.keys.first, note.values.first))
              .toList(),
        ),
      ),
    ],
  );
}

  Widget _buildStyleNote(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 16),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
