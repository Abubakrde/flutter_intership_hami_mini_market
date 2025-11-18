import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import '../state/cart_notifier.dart'; // Import the notifier

// Use the singleton instance
final CartNotifier cartNotifier = CartNotifier();

// This screen now acts as the main navigation container (tabs menu)
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // The list of widgets (screens) corresponding to each tab
  final List<Widget> _widgetOptions = <Widget>[
    // 0: Home Tab Content
    const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Hami MiniMarket 🍎',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Use the tabs below to browse products or view your cart.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
    ProductListScreen(), // 1: Products Tab
    CartScreen(), // 2: Cart Tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hami MiniMarket'),
        backgroundColor: Colors.green.shade700,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),

      // --- Bottom Navigation Bar with Cart Badge ---
      bottomNavigationBar: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: cartNotifier.cartItems,
        builder: (context, cartItems, child) {
          // Calculate total count of products (sum of quantities)
          final totalItemCount = cartItems.fold(
            0,
            (sum, item) => sum + ((item['quantity'] as int?) ?? 1),
          );

          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                label: 'Cart',
                icon: Stack(
                  clipBehavior:
                      Clip.none, // Allow badge to show outside the icon area
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (totalItemCount > 0)
                      Positioned(
                        right:
                            -8, // Adjusted position to place it near the top right of the icon
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$totalItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green.shade700,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
