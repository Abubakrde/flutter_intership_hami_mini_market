// File: lib/screens/cart_screen.dart (FIXED SYNTAX AND WIDGET DEFINITIONS)

import 'package:flutter/material.dart';
import '../state/cart_notifier.dart';
import 'checkout_summary_screen.dart';

// Use the singleton instance
final CartNotifier cartNotifier = CartNotifier();

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: cartNotifier.cartItems,
      builder: (context, cartItems, child) {
        // Calculate total amount
        double total = cartItems.fold(0.0, (sum, item) {
          final quantity = (item['quantity'] as int?) ?? 1;
          return sum + (item['price'] as num).toDouble() * quantity;
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart 🧺'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: cartItems.isNotEmpty ? cartNotifier.clearCart : null,
                tooltip: 'Clear Cart',
              ),
            ],
          ),
          body: cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items in the cart yet. Start shopping! 🛍️',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final quantity = (item['quantity'] as int?) ?? 1;
                          final itemSubtotal =
                              (item['price'] as num) * quantity;

                          return ListTile(
                            leading: Text(
                              item['image'],
                              style: const TextStyle(fontSize: 30),
                            ),
                            title: Text(item['name']),
                            subtitle: Text(
                              "\$${(item['price'] as num).toStringAsFixed(2)} x $quantity = \$${itemSubtotal.toStringAsFixed(2)}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      cartNotifier.updateQuantity(item, -1),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      cartNotifier.updateQuantity(item, 1),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // --- Total & Checkout Section ---
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Cart Total:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              // FIX: Ensure label is included here
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: total > 0
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CheckoutScreen(
                                            totalAmount: total,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              icon: const Icon(
                                Icons.payment,
                                color: Colors.white,
                              ),
                              label: const Text(
                                // FIX: This was missing and caused a compiler error
                                'Proceed to Checkout',
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
                  ],
                ),
        );
      },
    );
  }
}
