import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void main() => runApp(const ReceiptScannerApp());

class ReceiptScannerApp extends StatelessWidget {
  const ReceiptScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3157D5),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
      ),
      home: const ReceiptHomePage(),
    );
  }
}

class ReceiptItem {
  ReceiptItem(this.name, this.price, this.quantity);
  String name;
  double price;
  int quantity;
  double get total => price * quantity;
}

class ReceiptData {
  String merchant = 'Fresh Market';
  DateTime date = DateTime(2026, 9, 3);
  double subtotal = 42.50;
  double tax = 3.83;
  double total = 46.33;
  String paymentMethod = 'Card';

  final List<ReceiptItem> items = [
    ReceiptItem('Organic Apples', 6.50, 1),
    ReceiptItem('Whole Grain Bread', 4.25, 1),
    ReceiptItem('Coffee Beans', 14.75, 1),
    ReceiptItem('Pasta', 8.50, 1),
    ReceiptItem('Olive Oil', 8.50, 1),
  ];
}

class ReceiptHomePage extends StatefulWidget {
  const ReceiptHomePage({super.key});

  @override
  State<ReceiptHomePage> createState() => _ReceiptHomePageState();
}

class _ReceiptHomePageState extends State<ReceiptHomePage> {
  final ImagePicker _picker = ImagePicker();
  final ReceiptData _receipt = ReceiptData();
  XFile? _image;
  bool _isExtracting = false;

  Future<void> _pick(ImageSource source) async {
    final selected = await _picker.pickImage(source: source, imageQuality: 88);
    if (selected == null) return;
    setState(() {
      _image = selected;
      _isExtracting = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isExtracting = false);
  }

  void _showExported() {
    final date = DateFormat('yyyy-MM-dd').format(_receipt.date);
    final json = '{"merchant":"' + _receipt.merchant + '","date":"' +
        date + '","total":' + _receipt.total.toStringAsFixed(2) + '}';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt JSON'),
        content: SelectableText(json),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt Scanner'),
        actions: [
          IconButton(
            tooltip: 'Export JSON',
            onPressed: _showExported,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildCaptureCard()),
                            const SizedBox(width: 20),
                            Expanded(child: _buildReviewCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCaptureCard(),
                            const SizedBox(height: 20),
                            _buildReviewCard(),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCaptureCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capture a receipt',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 6),
            const Text(
                'Take a photo or choose an existing image. The demo keeps the workflow local-first.'),
            const SizedBox(height: 20),
            Container(
              height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFECEFF7),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFDCE1EE)),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_image == null ? Icons.receipt_long_rounded : Icons.check_circle_rounded,
                        size: 58),
                    const SizedBox(height: 12),
                    Text(_image == null ? 'No receipt selected' : 'Receipt selected'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isExtracting) const LinearProgressIndicator(minHeight: 3),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(avatar: Icon(Icons.lock_outline_rounded, size: 16), label: Text('Local-first')),
                Chip(avatar: Icon(Icons.auto_awesome_outlined, size: 16), label: Text('OCR-ready')),
                Chip(avatar: Icon(Icons.data_object_rounded, size: 16), label: Text('JSON export')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Review extracted data',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                ),
                const Chip(avatar: Icon(Icons.verified_rounded, size: 16), label: Text('Demo 96%')),
              ],
            ),
            const SizedBox(height: 18),
            _field('Merchant', _receipt.merchant, Icons.storefront_rounded),
            _field('Date', DateFormat('dd MMM yyyy').format(_receipt.date), Icons.calendar_today_rounded),
            _field('Payment', _receipt.paymentMethod, Icons.credit_card_rounded),
            const SizedBox(height: 10),
            Text('Items', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ..._receipt.items.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.name),
                  subtitle: Text(item.quantity.toString() + ' × ' + item.price.toStringAsFixed(2)),
                  trailing: Text(item.total.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
            const Divider(height: 22),
            _moneyRow('Subtotal', _receipt.subtotal),
            _moneyRow('Tax', _receipt.tax),
            const SizedBox(height: 8),
            _moneyRow('Total', _receipt.total, strong: true),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: _showExported, icon: const Icon(Icons.code_rounded), label: const Text('View JSON')),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _moneyRow(String label, double value, {bool strong = false}) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value.toStringAsFixed(2), style: style),
      ],
    );
  }
}
