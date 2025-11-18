// File: lib/screens/confirmation_screen.dart (FINALIZED)

import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import to navigate back to Home

class ConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  ConfirmationScreen({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items =
        orderDetails['items'] as List<Map<String, dynamic>>;
    final String customerName = orderDetails['name'] ?? 'Customer';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Thank You Message ---
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Order Received! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Thank you, $customerName. Your order details are below:',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // --- Delivery Details ---
            const Text(
              'Delivery Details 🚚',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildDetailRow('Name:', orderDetails['name'] ?? 'N/A'),
            _buildDetailRow('Phone:', orderDetails['phone'] ?? 'N/A'),
            _buildDetailRow('Address:', orderDetails['address'] ?? 'N/A'),
            const SizedBox(height: 20),

            // --- Order Summary ---
            const Text(
              'Order Summary 📋',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            // Expanded ListView for scrollable items
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  // Safely calculate subtotal
                  final quantity = (item['quantity'] as int?) ?? 1;
                  final subtotal = (item['price'] as num) * quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item['name']} (x$quantity)'),
                        Text('\$${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            _buildDetailRow(
              'FINAL TOTAL:',
              '\$${orderDetails['total'].toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 30),

            // --- Continue Shopping Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate back to the home screen and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
