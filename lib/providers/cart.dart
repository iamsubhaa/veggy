import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/models/index.dart';
import 'package:veggy/utills/index.dart';

class Cart extends ChangeNotifier {
  List<CartProduct> _cart = [];
  int _money = 0;
  get money => _money;
  void calMoney() {
    _cart.forEach((element) {
      int available = element.product.stock - int.parse(element.qty);
      if (available >= 0) {
        _money += (element.product.price * (100 - element.product.off) / 100)
                .round() *
            int.parse(element.qty);
      } else {
        _money += (element.product.price * (100 - element.product.off) / 100)
                .round() *
            (element.product.stock == 0 ? 0 : element.product.stock);
      }
    });
    print('money=>>>>>>>>>>>>>>>>$_money');
    notifyListeners();
  }

  get cart => _cart;
  void getCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('userId');
    final response = await Api().getWithToken('/carts?user=$userId');
    try {
      _cart = response
          .map((val) => CartProduct(
              id: val['id'].toString(),
              qty: val['qty'].toString(),
              product: Product.fromJSON(val['product'])))
          .toList();
      print(_cart);
    } catch (e) {
      print('cart item get err $e');
    }
    _money = 0;
    calMoney();
    notifyListeners();
  }

  void addCart(String productId, String qty) async {
    try {
      List<CartProduct> _temp = [];
      bool flag = false;
      _cart.forEach((element) async {
        if (element.product.id == productId) {
          print('matchedddddddddddddddddddddddddddddd');
          flag = true;
          _temp.add(CartProduct(
              id: element.id,
              qty: (int.parse(element.qty) + 1).toString(),
              product: element.product));
          Map body = {'qty': (int.parse(element.qty) + int.parse(qty)).toString()};
          final response = await Api()
              .putWithToken('/carts/${element.id}/', jsonEncode(body));
        } else {
          _temp.add(element);
        }
      });
      _cart = _temp;
      if (!flag) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String userId = pref.getString('userId');
        Map body = {"user": userId, 'product': productId, 'qty': qty};
        final response = await Api().postWithToken('/carts', body);
        CartProduct cp = CartProduct(
            id: response['id'].toString(),
            qty: response['qty'].toString(),
            product: Product.fromJSON(response['product']));
        _cart.add(cp);
      }
    } catch (e) {
      print('add cart err $e');
    }
    getCart();
    notifyListeners();
  }

  void removeCart(String cartProductId)async {
    try{
      final response = await Api().deleteWithToken('/carts/$cartProductId/');
      _cart = _cart.where((element) => element.id!=cartProductId).toList();
    }catch(e){
      print('delete from cart err $e');
    }
    getCart();
    notifyListeners();
  }
}
