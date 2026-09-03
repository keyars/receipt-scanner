import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_scanner/main.dart';

void main() {
  testWidgets('Receipt Scanner renders capture and review sections', (tester) async {
    await tester.pumpWidget(const ReceiptScannerApp());
    expect(find.text('Capture a receipt'), findsOneWidget);
    expect(find.text('Review extracted data'), findsOneWidget);
    expect(find.text('Fresh Market'), findsOneWidget);
  });
}
