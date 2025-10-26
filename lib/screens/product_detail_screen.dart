import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.product['image'], style: TextStyle(fontSize: 60)),
            SizedBox(height: 10),
            Text(widget.product['description']),
            SizedBox(height: 10),
            Text('Price: \$${widget.product['price']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                CartScreen.cartItems.add(widget.product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart')),
                );
              },
              child: Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
}
