// File: lib/state/cart_notifier.dart (FINAL CORRECTED)

import 'package:flutter/material.dart';

// Defines a ValueNotifier to manage and update the cart list across the app
class CartNotifier {
  // The ValueNotifier holds the list of cart items and notifies listeners on change
  final ValueNotifier<List<Map<String, dynamic>>> cartItems =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // Singleton setup for easy access anywhere in the app
  CartNotifier._internal();
  static final CartNotifier _instance = CartNotifier._internal();
  factory CartNotifier() => _instance;

  // Getter for the current list
  List<Map<String, dynamic>> get items => cartItems.value;

  // --- Cart Modification Methods ---

  /// Updates the quantity of an existing item in the cart.
  void updateQuantity(Map<String, dynamic> item, int change) {
    // Work on a mutable copy of the list value
    final currentCart = List<Map<String, dynamic>>.from(items);

    final existingItemIndex = currentCart.indexWhere(
      (i) => i['name'] == item['name'],
    );

    if (existingItemIndex != -1) {
      int currentQuantity =
          (currentCart[existingItemIndex]['quantity'] as int?) ?? 1;
      final newQuantity = currentQuantity + change;

      if (newQuantity > 0) {
        currentCart[existingItemIndex]['quantity'] = newQuantity;
      } else {
        // Remove item if quantity drops to 0
        currentCart.removeAt(existingItemIndex);
      }
      // Crucial step: Reassign the list value to notify all ValueListenableBuilders
      cartItems.value = currentCart;
    }
  }

  /// Adds a product to the cart, or increments its quantity if it already exists.
  void addToCart(Map<String, dynamic> product) {
    // Work on a mutable copy of the list value
    final currentCart = List<Map<String, dynamic>>.from(items);

    final existingItemIndex = currentCart.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingItemIndex != -1) {
      int currentQuantity =
          (currentCart[existingItemIndex]['quantity'] as int?) ?? 1;
      currentCart[existingItemIndex]['quantity'] = currentQuantity + 1;
    } else {
      final productWithQuantity = Map<String, dynamic>.from(product);
      productWithQuantity['quantity'] = 1;
      currentCart.add(productWithQuantity);
    }
    // Reassign the list value to notify all ValueListenableBuilders
    cartItems.value = currentCart;
  }

  /// Clears all items from the cart.
  void clearCart() {
    cartItems.value = [];
  }
}
