import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/utills/index.dart';

class Api {
  static Api _instance = new Api.internal();
  Api.internal();
  factory Api() => _instance;
  Future<List> get(String url) async {
    print('Api url $url');
    try {
      final response = await http.get(BASE_URL + url);
      if (response.statusCode == 400 || response.statusCode == 200) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return [];
    }
  }

  Future deleteWithToken(String url) async {
    print('Api url $url');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('jwt');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await http.delete(BASE_URL + url,headers: headers);
      print('api response ${response.statusCode} \n $token \n ${response.body}');
      if (response.statusCode == 400 || response.statusCode == 200) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return [];
    }
  }

  Future<List> getWithToken(String url) async {
    print('Api url $url');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('jwt');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response = await http.get(BASE_URL + url, headers: headers);
      print('api response ${response.statusCode} \n $token');
      if (response.statusCode == 400 || response.statusCode == 200) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return [];
    }
  }

  Future postWithToken(String url, body) async {
    print('Api url $url');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('jwt');
      Map<String, String> headers = {"Authorization": "Bearer $token"};
      final response =
          await http.post(BASE_URL + url, body: body, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return [];
    }
  }

  Future putWithToken(String url, body) async {
    print('Api url $url');
    // try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt');
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      'Accept': 'application/json',
    };
    print('ffffff');
    final response =
        await http.put(BASE_URL + url, body: body, headers: headers);
    print('${response.statusCode}====>${response.body}');
    if (response.statusCode == 200 || response.statusCode == 400) {
      var parsed = json.decode(response.body);
      print('Api Called $parsed');
      return parsed;
    } else {
      throw Exception('Unable to fetch');
    }
    // } catch (e) {
    //   print('Api putWithToken err $e');
    //   return [];
    // }
  }

  Future post(String url, body) async {
    print('Api url $url');
    try {
      final response = await http.post(BASE_URL + url, body: body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return [];
    }
  }

  Future login(String url, body) async {
    print('Api url $url');
    try {
      final response = await http.post(BASE_URL + url, body: body);
      print('Api response code ${response.statusCode} \n ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 400) {
        var parsed = json.decode(response.body);
        print('Api Called $parsed');
        return parsed;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      print('Api err $e');
      return {};
    }
  }
}
