import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pos_model.dart';

void main() {
  runApp(const StockPilotApp());
}

class StockPilotApp extends StatelessWidget {
  const StockPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosModel(),
      child: MaterialApp(
        title: 'StockPilot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF355070),
            primary: const Color(0xFF355070),
            secondary: const Color(0xFFE09F3E),
            background: const Color(0xFFF3F5F7),
          ),
        ),
        home: const CounterGate(),
      ),
    );
  }
}

class CounterGate extends StatelessWidget {
  const CounterGate({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<PosModel>().signedIn
        ? const CounterPage()
        : const SignInPage();
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'clerk@stockpilot.dev');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('StockPilot',
                style: Theme.of(context).textTheme.headlineMedium),
            const Text(
                'Counter demo. GST is tax-exclusive and calculated in cents.'),
            const SizedBox(height: 16),
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            Text(context.watch<PosModel>().error ?? ''),
            FilledButton(
              onPressed: () =>
                  context.read<PosModel>().signIn(_email.text, _password.text),
              child: const Text('Open counter'),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PosModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Day counter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('BOLT-8 on hand: ${model.ledger.onHand['BOLT-8']}'),
          Text('GLOVE-M on hand: ${model.ledger.onHand['GLOVE-M']}'),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: model.sellBolt, child: const Text('Sell 2 bolts')),
          Text(model.error ?? ''),
          for (final line in model.lines) Text('${line.sku} × ${line.qty}'),
          Text('Invoice total \$${(model.total / 100).toStringAsFixed(2)}'),
          const Text('Thermal printing is a mock. No device claim is made.'),
        ],
      ),
    );
  }
}
