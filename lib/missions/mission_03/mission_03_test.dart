import 'package:flutter/material.dart';
import 'package:test_vuln/missions/step_layout.dart';
import 'package:test_vuln/missions/mission_03/mission_03_identify.dart';

class Mission03Test extends StatefulWidget {
  const Mission03Test({Key? key}) : super(key: key);

  @override
  State<Mission03Test> createState() => _Mission03TestState();
}

class _Mission03TestState extends State<Mission03Test> {
  final TextEditingController _orderIdController = TextEditingController();
  String _resultMessage = '';
  bool _isOrderAccessed = false;
  String _currentOrderId = '';

  final Map<String, Map<String, String>> _orders = {
    '1': {
      'customer': 'Jane Smith (jane.smith@example.com)',
      'items': 'Laptop, Laptop Bag, USB-C Cable',
      'total': '\$1,249.99',
      'status': 'Processing',
      'address': '456 Oak Avenue, Metropolis',
    },
    '2': {
      'customer': 'Bob Wilson (bob.w@example.com)',
      'items': 'Smartphone, Screen Protector, Case',
      'total': '\$799.99',
      'status': 'Shipped',
      'address': '789 Pine Road, Gotham City',
    },
    '3': {
      'customer': 'Alice Johnson (alice.j@example.com)',
      'items': 'Headphones, Bluetooth Speaker',
      'total': '\$199.99',
      'status': 'Delivered',
      'address': '321 Elm Street, Star City',
    },
  };

  void _testOrderAccess() {
    final orderId = _orderIdController.text.trim();

    if (orderId == '1' || orderId == '2' || orderId == '3') {
      final order = _orders[orderId]!;
      setState(() {
        _isOrderAccessed = true;
        _currentOrderId = orderId;
        _resultMessage = '✅ ORDER ACCESSED!\n\n'
            'You successfully accessed order #$orderId!\n\n'
            'Order Details:\n'
            '• Customer: ${order['customer']}\n'
            '• Items: ${order['items']}\n'
            '• Total: ${order['total']}\n'
            '• Status: ${order['status']}\n'
            '• Shipping Address: ${order['address']}\n\n'
            'By changing the numeric ID in the URL, you accessed another user\'s order. The server returned data without verifying ownership.';
      });
    } else {
      setState(() {
        _isOrderAccessed = false;
        _currentOrderId = '';
        _resultMessage = '❌ Order not found.';
      });
    }
  }

  void _resetToOwnOrder() {
    _orderIdController.clear();
    setState(() {
      _isOrderAccessed = false;
      _currentOrderId = '';
      _resultMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepLayout(
      stepNumber: 'STEP 2 OF 5',
      stepTitle: 'Test the Vulnerability',
      onNextPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mission03Identify()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFE68C8C).withOpacity(0.15),
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE68C8C).withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Color(0xFFE68C8C), size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    '/orders/detail?id=',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 60,
                    child: TextField(
                      controller: _orderIdController,
                      style: const TextStyle(color: Color(0xFFE68C8C), fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testOrderAccess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE68C8C),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'ACCESS ORDER',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_resultMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isOrderAccessed
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isOrderAccessed ? Colors.green : Colors.red,
                  ),
                ),
                child: Text(
                  _resultMessage,
                  style: TextStyle(
                    color: _isOrderAccessed ? Colors.green : Colors.red,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            if (_resultMessage.isNotEmpty && _currentOrderId.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _resetToOwnOrder,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Different ID'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE68C8C),
                    side: const BorderSide(color: Colors.white38),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}