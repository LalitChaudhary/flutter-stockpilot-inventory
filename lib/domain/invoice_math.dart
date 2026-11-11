class InvoiceLine {
  const InvoiceLine({
    required this.sku,
    required this.qty,
    required this.unitMinor,
    required this.discountBps,
    required this.gstBps,
  });

  final String sku;
  final int qty;
  final int unitMinor;
  final int discountBps;
  final int gstBps;
}

class InvoiceMath {
  const InvoiceMath();

  /// Tax-exclusive: discount applies to the line, then GST is added.
  int lineTotalMinor(InvoiceLine line) {
    final gross = line.unitMinor * line.qty;
    final discount = (gross * line.discountBps) ~/ 10000;
    final net = gross - discount;
    final tax = (net * line.gstBps) ~/ 10000;
    return net + tax;
  }

  int invoiceMinor(List<InvoiceLine> lines) =>
      lines.fold(0, (sum, line) => sum + lineTotalMinor(line));
}

class StockMove {
  const StockMove({required this.sku, required this.delta});
  final String sku;
  final int delta;
}

class StockLedger {
  final Map<String, int> onHand = {};

  void apply(List<StockMove> moves) {
    for (final move in moves) {
      final next = (onHand[move.sku] ?? 0) + move.delta;
      if (next < 0) {
        throw StateError('${move.sku} would go negative.');
      }
      onHand[move.sku] = next;
    }
  }
}
