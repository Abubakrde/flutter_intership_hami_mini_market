// File: product_detail_screen.dart

import 'package:flutter/material.dart';
// Import the CartNotifier
import '../state/cart_notifier.dart';

// Get the singleton instance of the cart notifier
final CartNotifier cartNotifier = CartNotifier();

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // --- Fixed Add to Cart Logic using Notifier ---
  void _addToCart() {
    // FIX: Correcting the method name from 'addItem' to 'addToCart'.
    cartNotifier.addToCart(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product['name']} added to cart! Check your cart tab.',
        ),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safely parse the price
    final price = (widget.product['price'] as num).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image/Emoji
            Text(
              widget.product['image'],
              style: const TextStyle(fontSize: 60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Product Description
            Text(
              widget.product['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Product Price
            Text(
              'Price: \$$price',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _addToCart,
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
