import 'package:flutter/material.dart';
import 'package:mind_insight/src/features/chat/presentation/widget/genui/card_shuffle_widget.dart';

/// Standalone app to test CardShuffleWidget independently.
///
/// Run with:
///   flutter run -t lib/card_shuffle_test_app.dart
void main() {
  runApp(const CardShuffleTestApp());
}

class CardShuffleTestApp extends StatelessWidget {
  const CardShuffleTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardShuffle Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7C6FCB),
        useMaterial3: true,
      ),
      home: const CardShuffleTestScreen(),
    );
  }
}

class CardShuffleTestScreen extends StatefulWidget {
  const CardShuffleTestScreen({super.key});

  @override
  State<CardShuffleTestScreen> createState() => _CardShuffleTestScreenState();
}

class _CardShuffleTestScreenState extends State<CardShuffleTestScreen> {
  String _lastAction = '';
  Map<String, dynamic> _lastData = {};

  // Tweak these to test different scenarios
  int _requiredCards = 3;
  final List<String> _positions = ['过去', '现在', '未来'];

  void _handleAction(String action, Map<String, dynamic> data) {
    setState(() {
      _lastAction = action;
      _lastData = data;
    });
    debugPrint('--- GenUI Action ---');
    debugPrint('Action: $action');
    debugPrint('Data: $data');
  }

  void _resetWidget() {
    setState(() {
      _lastAction = '';
      _lastData = {};
      // Force rebuild by changing key
      _widgetKey = UniqueKey();
    });
  }

  Key _widgetKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CardShuffleWidget Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset widget',
            onPressed: _resetWidget,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Configuration panel ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('requiredCards: '),
                        DropdownButton<int>(
                          value: _requiredCards,
                          items: [1, 2, 3, 4, 5]
                              .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _requiredCards = v);
                              _resetWidget();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- The widget under test ---
            CardShuffleWidget(
              key: _widgetKey,
              data: {
                'requiredCards': _requiredCards,
                'spreadName': 'Test Spread',
                'positions': _positions.take(_requiredCards).toList(),
                'tarotSessionId': 42,
              },
              onAction: _handleAction,
            ),

            const SizedBox(height: 24),

            // --- Action log ---
            Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (_lastAction.isEmpty)
                      const Text('No action triggered yet', style: TextStyle(color: Colors.grey))
                    else ...[
                      Text('Action: $_lastAction', style: const TextStyle(fontFamily: 'monospace')),
                      const SizedBox(height: 4),
                      Text('Data: $_lastData', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
