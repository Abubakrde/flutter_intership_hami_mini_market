// File: cart_screen.dart

import 'package:flutter/material.dart';
import 'checkout_screen.dart'; // Import new screen

class CartScreen extends StatefulWidget {
  // Structure: [{product details..., 'quantity': 1}, ...]
  static List<Map<String, dynamic>> cartItems = [];

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // --- Quantity Management Functions with Null Safety ---

  void _updateQuantity(int index, int change) {
    setState(() {
      // Safely retrieve current quantity, defaulting to 1 if null/missing
      int currentQuantity =
          (CartScreen.cartItems[index]['quantity'] as int?) ?? 1;
      final newQuantity = currentQuantity + change;

      if (newQuantity > 0) {
        // Increase/Decrease quantity
        CartScreen.cartItems[index]['quantity'] = newQuantity;
      } else {
        // Remove item if quantity drops to 0
        CartScreen.cartItems.removeAt(index);
      }
    });
  }

  void _clearCart() {
    setState(() {
      CartScreen.cartItems.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cart cleared successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total price: SUM(price * quantity). Use null-aware operator for safety.
    double total = CartScreen.cartItems.fold(0.0, (sum, item) {
      final quantity =
          (item['quantity'] as int?) ?? 1; // Safely default quantity to 1
      return sum + (item['price'] as num) * quantity;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart 🧺'),
        actions: [
          // Optional Bonus: Clear Cart Button
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearCart,
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: CartScreen.cartItems.isEmpty
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
                    itemCount: CartScreen.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = CartScreen.cartItems[index];
                      final quantity =
                          (item['quantity'] as int?) ?? 1; // Use safe quantity
                      final itemSubtotal = (item['price'] as num) * quantity;

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
                              onPressed: () => _updateQuantity(index, -1),
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
                              onPressed: () => _updateQuantity(index, 1),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: total > 0
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CheckoutScreen(totalAmount: total),
                                    ),
                                  );
                                }
                              : null,
                          icon: const Icon(Icons.payment, color: Colors.white),
                          label: const Text(
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
  }
}
