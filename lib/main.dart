import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/utills/index.dart';
import './pages/index.dart';

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("loggedIn");
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Veggy',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData)
            return MyHomePage(title: 'Veggy');
          else if (snapshot.hasError || snapshot.data==null)
            return AuthPage();
          else {
            return SplashPage();
          }
        },
      ),
      routes: {
        RouterName.MAIN_APP: (context) => MyHomePage(title: 'Veggy'),
        RouterName.AUTH_APP: (context) => AuthPage(),
      },
    );
  }
}
