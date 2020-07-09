import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff28292E),
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Veggy',
                  style: TextStyle(
                      fontSize: 110,
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20,),
              CircularProgressIndicator()
            ]),
          ),
        ));
  }
}
