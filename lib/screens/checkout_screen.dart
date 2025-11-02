// File: checkout_screen.dart

import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  CheckoutScreen({required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _address = '';

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Store current cart items before clearing them
      final List<Map<String, dynamic>> itemsSnapshot = CartScreen.cartItems
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      // Navigate to confirmation screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            orderDetails: {
              'name': _name,
              'phone': _phone,
              'address': _address,
              'total': widget.totalAmount,
              'items': itemsSnapshot,
            },
          ),
        ),
      );

      // Clear cart immediately after successful submission/navigation
      CartScreen.cartItems.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Payable: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Divider(height: 30),

              // Name Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 15),

              // Phone Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  // Basic phone number validation
                  if (value == null || value.isEmpty || value.length < 7) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 15),

              // Address Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a delivery address';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 30),

              // Confirm Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitOrder,
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Confirm Order',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
