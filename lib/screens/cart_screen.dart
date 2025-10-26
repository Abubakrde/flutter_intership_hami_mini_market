import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = CartScreen.cartItems.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: CartScreen.cartItems.isEmpty
          ? Center(child: Text('No items in the cart'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: CartScreen.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = CartScreen.cartItems[index];
                      return ListTile(
                        leading: Text(item['image'], style: TextStyle(fontSize: 30)),
                        title: Text(item['name']),
                        subtitle: Text("\$${item['price']}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Total: \$${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
    );
  }
}
