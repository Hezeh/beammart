import 'package:beammart/models/cart_item_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  CartItemModel? _cartItem;

  CartItemModel? get cartItem => _cartItem;

  addToCart() {
    if (_cartItem != null) {
      _cartItem!.quantity += 1;
    }
  }

  removeFromCart() {
    
  }

  // If there is an item in the cart
  // Check whether the merchantId is similar
  // If not prompt the user to change merchants
  // If yes proceed
}
