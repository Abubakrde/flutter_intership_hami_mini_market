// File: product_detail_screen.dart

import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // --- Updated Add to Cart Logic with Null Safety ---
  void _addToCart() {
    // 1. Check if item already exists in the cart (by 'name')
    final existingItemIndex = CartScreen.cartItems.indexWhere(
      (item) => item['name'] == widget.product['name'],
    );

    setState(() {
      if (existingItemIndex != -1) {
        // 2. If it exists, safely retrieve existing quantity (defaulting to 1 if null/missing), then increment.
        int currentQuantity =
            (CartScreen.cartItems[existingItemIndex]['quantity'] as int?) ?? 1;
        CartScreen.cartItems[existingItemIndex]['quantity'] =
            currentQuantity + 1;
      } else {
        // 3. If it's new, add the product map with quantity 1
        final productWithQuantity = Map<String, dynamic>.from(widget.product);
        productWithQuantity['quantity'] = 1;
        CartScreen.cartItems.add(productWithQuantity);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product['name']} added to cart! Quantity updated.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.product['image'], style: TextStyle(fontSize: 60)),
            SizedBox(height: 10),
            Text(widget.product['description']),
            SizedBox(height: 10),
            Text(
              'Price: \$${widget.product['price']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _addToCart,
              icon: Icon(Icons.add_shopping_cart, color: Colors.white),
              label: Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
