// File: lib/providers/cart_provider.dart (COMPLETE)

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class representing an item in the cart
class CartItem {
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'image': image,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    name: json['name'],
    price: json['price'].toDouble(),
    image: json['image'],
    quantity: json['quantity'],
  );
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  static const _cartKey = 'cartItems';
  static const double taxRate = 0.05; // 5% tax

  // Loads cart when the app starts
  CartProvider() {
    _loadCart();
  }

  // --- Getters for UI Access ---
  List<CartItem> get items => _items;
  int get totalQuantity {
    return _items.fold(0, (sum, current) => sum + current.quantity);
  }

  double get subtotal {
    return _items.fold(
      0.0,
      (sum, current) => sum + (current.price * current.quantity),
    );
  }

  double get taxAmount {
    return subtotal * taxRate;
  }

  double get finalTotal {
    double calculatedTotal = subtotal + taxAmount;
    // Optional Bonus: 10% discount if total > $50
    if (calculatedTotal > 50.00) {
      calculatedTotal *= 0.90;
    }
    return calculatedTotal;
  }

  // --- Persistence & Logic ---
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      final List<dynamic> decodedList = json.decode(cartJson);
      _items = decodedList
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList();
      // Notify listeners only after loading is complete
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = _items
        .map((item) => item.toJson())
        .toList();
    await prefs.setString(_cartKey, json.encode(jsonList));
  }

  // CORE FIX: Logic to add an item
  void addItem(Map<String, dynamic> product) {
    // 1. Check if the product already exists
    final existingItemIndex = _items.indexWhere(
      (item) => item.name == product['name'],
    );

    if (existingItemIndex != -1) {
      // 2. If it exists, increment quantity
      _items[existingItemIndex].quantity += 1;
    } else {
      // 3. If it's new, add a new CartItem object
      _items.add(
        CartItem(
          name: product['name'],
          price: product['price'].toDouble(),
          image: product['image'],
          quantity: 1, // Start with 1
        ),
      );
    }
    _saveCart();
    notifyListeners();
  }

  // CORE FIX: Logic to update quantity (used in CartScreen)
  void updateQuantity(CartItem item, int change) {
    final index = _items.indexOf(item);
    if (index != -1) {
      final newQuantity = _items[index].quantity + change;

      if (newQuantity > 0) {
        // Update quantity
        _items[index].quantity = newQuantity;
      } else {
        // Remove item if quantity drops to 0
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }
}
