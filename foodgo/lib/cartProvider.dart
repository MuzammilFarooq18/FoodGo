
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get cartQuantity => _cartItems.fold(0, (sum, item) => sum + item['quantity']);

  void addItem(String name, int quantity, double price) {
    // Check if item already exists in the cart
    for (var item in _cartItems) {
      if (item['name'] == name) {
        item['quantity'] += quantity; // Increase the quantity if exists
        notifyListeners();
        return;
      }
    }

    // If it doesn't exist, add a new item
    Map<String, dynamic> newItem = {
      'name': name,
      'quantity': quantity,
      'price': price,
    };

    _cartItems.add(newItem);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
