import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/providers/favourite.dart';
import 'package:veggy/providers/index.dart';
import 'package:veggy/utills/index.dart';
import './pages/index.dart';

Future<bool> isLoggedIn(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('userId');
  String email = prefs.getString('email');
  String username = prefs.getString('username');
  String address = prefs.getString('address');
  String gender = prefs.getString('gender');
  Provider.of<LoginApp>(context,listen: false).setUser(id, username, email, gender, address);
  Provider.of<Favouite>(context,listen: false).getFav(id);
  return prefs.getBool("loggedIn");
}

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LoginApp()),
    ChangeNotifierProvider(create: (_)=>Favouite()),
    ChangeNotifierProvider(create: (_)=>Cart()),
    ],
    child: MyApp(),
  ));
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
        future: isLoggedIn(context),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData)
            return MyHomePage(title: 'Veggy');
          else if (snapshot.hasError || snapshot.data == null)
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
