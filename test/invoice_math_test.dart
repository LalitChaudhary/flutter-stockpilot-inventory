import 'package:flutter_test/flutter_test.dart';
import 'package:stockpilot/domain/invoice_math.dart';

void main() {
  const math = InvoiceMath();

  test('discount then 18 percent GST stays in minor units', () {
    const line = InvoiceLine(
      sku: 'BOLT-8',
      qty: 2,
      unitMinor: 1500,
      discountBps: 500,
      gstBps: 1800,
    );
    const gross = 3000;
    const discount = 150;
    const tax = ((gross - discount) * 1800) ~/ 10000;
    expect(math.lineTotalMinor(line), gross - discount + tax);
  });

  test('stock cannot go negative', () {
    final ledger = StockLedger();
    ledger.apply(const [StockMove(sku: 'A', delta: 1)]);
    expect(() => ledger.apply(const [StockMove(sku: 'A', delta: -2)]),
        throwsStateError);
  });
}
