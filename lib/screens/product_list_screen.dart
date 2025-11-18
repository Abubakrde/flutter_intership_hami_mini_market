// File: lib/screens/product_list_screen.dart (UPDATED: Add-to-Cart & Favorite)

import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import 'product_detail_screen.dart';
import '../state/cart_notifier.dart'; // Import the new Notifier

// Global list to track favorites across sessions (simple implementation)
List<String> favoriteProductNames = [];

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CartNotifier cartNotifier = CartNotifier();

  void _toggleFavorite(String productName) {
    setState(() {
      if (favoriteProductNames.contains(productName)) {
        favoriteProductNames.remove(productName);
      } else {
        favoriteProductNames.add(productName);
      }
    });
  }

  void _addToCartSimple(Map<String, dynamic> product) {
    cartNotifier.addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits & Vegetables')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjusted ratio
        ),
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          final isFavorite = favoriteProductNames.contains(product['name']);

          return Card(
            color: Colors.green.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Column(
              children: [
                // 💖 Favorite Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade600,
                    ),
                    onPressed: () => _toggleFavorite(product['name']),
                  ),
                ),

                // Product Image (Emoji) - Tappable for details
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Text(
                    product['image'],
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 5),

                // Name and Price (now prominent)
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "\$${product['price'].toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),

                // 🛒 Simple Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => _addToCartSimple(product),
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
