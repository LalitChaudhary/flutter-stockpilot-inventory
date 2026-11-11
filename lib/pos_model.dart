import 'package:flutter/foundation.dart';

import 'domain/invoice_math.dart';

class PosModel extends ChangeNotifier {
  bool signedIn = false;
  String? error;
  final ledger = StockLedger();
  final lines = <InvoiceLine>[];

  PosModel() {
    ledger.apply(const [
      StockMove(sku: 'BOLT-8', delta: 40),
      StockMove(sku: 'GLOVE-M', delta: 12),
    ]);
  }

  void signIn(String email, String password) {
    if (email.trim() == 'clerk@stockpilot.dev' && password == 'demo1234') {
      signedIn = true;
      error = null;
    } else {
      error = 'Use the counter demo account.';
    }
    notifyListeners();
  }

  void sellBolt() {
    try {
      ledger.apply(const [StockMove(sku: 'BOLT-8', delta: -2)]);
      lines.add(const InvoiceLine(
        sku: 'BOLT-8',
        qty: 2,
        unitMinor: 1500,
        discountBps: 500,
        gstBps: 1800,
      ));
      error = null;
    } on StateError catch (err) {
      error = err.message;
    }
    notifyListeners();
  }

  int get total => const InvoiceMath().invoiceMinor(lines);
}
