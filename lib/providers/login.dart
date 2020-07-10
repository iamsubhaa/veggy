import 'package:flutter/material.dart';
import 'package:veggy/models/index.dart';

class LoginApp extends ChangeNotifier{
  User _user;
  void setUser(id,username,email,gender,address){
    _user = new User(id:id,username: username,email: email,gender: gender,address: address);
    notifyListeners();
  }
  get user => _user;
}