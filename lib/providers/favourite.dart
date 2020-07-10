import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/utills/index.dart';

class Favouite extends ChangeNotifier {
  List _fav = [];
  void getFav(String userId) async {
    final response = await Api().getWithToken('/favourites?user=$userId');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('favId', response[0]['id'].toString() ?? "");
      _fav =
          response[0]['products'].map((val) => val['id'].toString()).toList()??[];
    } catch (e) {
      print('favourite get err $e');
    }
    notifyListeners();
  }

  void setFav(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String favId = prefs.getString('favId');
    List _tempfav = _fav;
    if (_fav.contains(productId)) {
      _tempfav.remove(productId);
      Map<String, dynamic> body = {"products": _tempfav};
      try {
        await Api().putWithToken('/favourites/$favId/',jsonEncode(body));
        _fav.remove(productId);
      } catch (e) {
        print('add favouite with put err $e');
      }
    } else {
      _tempfav.add(productId);
      String userId = prefs.getString('userId');
      if (favId==null || favId == "") {
        Map<String, dynamic> body = {"user": userId, "products": productId};
        try {
          final response = await Api().postWithToken('/favourites', body);
          await prefs.setString('favId', response['id'].toString() ?? "");
          _fav.add(productId);
        } catch (e) {
          print('un favouite with post err $e');
        }
      } else {
        Map<String, dynamic> body = {"products": _tempfav};
        try {
          await Api().putWithToken('/favourites/$favId/', jsonEncode(body));
          _fav.add(productId);
        } catch (e) {
          print('un favouite with put err $e');
        }
      }
    }
    notifyListeners();
  }
  get fav => _fav;
}
