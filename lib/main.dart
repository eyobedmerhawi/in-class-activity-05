// BLOCK 1: Import Flutter's Material widgets and launch the app.
import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

// BLOCK 2: This app shell does not change, so it is a StatelessWidget.
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

// BLOCK 3: This screen changes after user interactions, so it is stateful.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // BLOCK 4: State fields determine what the user sees at any moment.
  int _counter = 40;
  int _increment = 7;
  final List<int> _history = [];

  final TextEditingController _incrementController = TextEditingController(
    text: '7',
  );

  int? _sliderStartValue;

  @override
  void dispose() {
    // Controllers use resources; dispose them when this screen is removed.
    _incrementController.dispose();
    super.dispose();
  }

  // BLOCK 5: Helper methods enforce rules before they change UI state.
  bool _isValidValue(int value) => value >= 10 && value <= 150;

  // Activity 05 color-feedback rule.
  Color _counterColor() {
    if (_counter == 10) return Colors.red;
    if (_counter > 90) return Colors.green;
    return Colors.black;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _moveTo(int nextValue) {
    // Reject invalid values BEFORE changing state or history.
    if (!_isValidValue(nextValue)) {
      if (nextValue < 10) {
        _showMessage('Minimum reached. Counter cannot go below 10.');
      } else {
        _showMessage('Maximum reached. Counter cannot go above 150.');
      }
      return;
    }

    // No history entry if the value does not actually change.
    if (nextValue == _counter) {
      return;
    }

    setState(() {
      _history.add(_counter);
      _counter = nextValue;
    });
  }

  void _readIncrement(String input) {
    final value = int.tryParse(input.trim());

    // Invalid input keeps the previous valid increment unchanged.
    if (value == null || value <= 0) {
      _showMessage(
        'Invalid increment. Enter a positive whole number greater than 0.',
      );
      return;
    }

    setState(() {
      _increment = value;
    });

    _showMessage('Increment successfully set to $value.');
  }

  void _setIncrement() {
    _readIncrement(_incrementController.text);
  }

  void _undo() {
    if (_history.isEmpty) {
      _showMessage('There is no earlier value to restore.');
      return;
    }

    setState(() {
      _counter = _history.removeLast();
    });
  }

  void _reset() {
    if (_counter != 10) {
      _moveTo(10);
    }
  }

  // Save the counter value where the slider drag started.
  void _startSlider(double value) {
    _sliderStartValue = _counter;
  }

  // Update the displayed counter while dragging.
  void _changeSlider(double value) {
    setState(() {
      _counter = value.round();
    });
  }

  // Save one meaningful history entry when the drag finishes.
  void _endSlider(double value) {
    final startValue = _sliderStartValue;
    final endValue = value.round();

    if (startValue != null && startValue != endValue) {
      setState(() {
        _history.add(startValue);
        _counter = endValue;
      });
    }

    _sliderStartValue = null;
  }

  @override
  Widget build(BuildContext context) {
    // BLOCK 6: Build reads state and connects widgets to user actions.
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 05 Counter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$_counter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: _counterColor()),
            ),

            Slider(
              value: _counter.toDouble(),
              min: 10,
              max: 150,
              divisions: 140,
              label: '$_counter',
              onChangeStart: _startSlider,
              onChanged: _changeSlider,
              onChangeEnd: _endSlider,
            ),

            TextField(
              controller: _incrementController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: 'Increment amount',
                helperText: 'Current valid increment: $_increment',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _setIncrement(),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: _setIncrement,
              child: const Text('Set Increment'),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _moveTo(_counter - _increment),
                  child: const Text('Decrease'),
                ),
                ElevatedButton(
                  onPressed: () => _moveTo(_counter + _increment),
                  child: const Text('Increase'),
                ),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset to 10'),
                ),
                OutlinedButton(onPressed: _undo, child: const Text('Undo')),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              _history.isEmpty
                  ? 'History: none'
                  : 'History: ${_history.join(', ')}',
            ),
          ],
        ),
      ),
    );
  }
}
