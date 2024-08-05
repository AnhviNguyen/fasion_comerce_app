import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key});

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  bool _isShowCentimetersSize = false;

  void updateSizes() {
    setState(() {
      _isShowCentimetersSize = !_isShowCentimetersSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Size guide'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: !_isShowCentimetersSize ? updateSizes : null,
                    child: Text('Centimeters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isShowCentimetersSize ? primaryColor : Colors.white, // Chọn màu nền chính khi không chọn
                      foregroundColor: !_isShowCentimetersSize ? Colors.white : Colors.black, // Chọn màu chữ khi không chọn
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isShowCentimetersSize ? updateSizes : null,
                    child: Text('Inches'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isShowCentimetersSize ? primaryColor : Colors.white, // Chọn màu nền chính khi chọn
                      foregroundColor: _isShowCentimetersSize ? Colors.white : Colors.black, // Chọn màu chữ khi chọn
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isShowCentimetersSize ? buildCentimeterTable() : buildInchesTable(),
            SizedBox(height: 24),
            Text('Measurement Guide', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 16),
            buildMeasurementGuide('Bust', 'Measure under your arms at the fullest part of your bust. Be sure to go over your shoulder blades.'),
            SizedBox(height: 16),
            buildMeasurementGuide('Natural Waist', 'Measure around the narrowest part of your waistline with one forefinger between your body and the measuring tape.'),
          ],
        ),
      ),
    );
  }

  Widget buildInchesTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      children: [
        buildTableRow(['Size', 'Bust', 'Waist', 'Hips'], isHeader: true),
        buildTableRow(['S', '2-4', '23-25', '34-35']),
        buildTableRow(['M', '6-8', '26-27', '36-39']),
        buildTableRow(['L', '9-10', '28-30', '40-42']),
        buildTableRow(['XL', '11-12', '31-33', '40-44']),
      ],
    );
  }

  Widget buildCentimeterTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey[300]!),
      children: [
        buildTableRow(['Size', 'Bust', 'Waist', 'Hips'], isHeader: true),
        buildTableRow(['S', '81-86', '58-63', '86-89']),
        buildTableRow(['M', '91-96', '66-69', '91-99']),
        buildTableRow(['L', '101-106', '71-76', '102-107']),
        buildTableRow(['XL', '111-116', '79-84', '102-112']),
      ],
    );
  }

  TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) => TableCell(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget buildMeasurementGuide(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        SizedBox(height: 4),
        Text(description, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}
