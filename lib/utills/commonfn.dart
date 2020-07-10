import 'package:flutter/material.dart';

void showSnackBar(context, String msg,
    {scaffoldkey, String buttonTitle, Function callback}) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
    action: SnackBarAction(
      label: buttonTitle ?? 'Close',
      onPressed: callback ??
          () {
            try {
              scaffoldkey.currentState.hideCurrentSnackBar();
            } catch (e) {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
    ),
  );
  try {
    scaffoldkey.currentState.hideCurrentSnackBar();
  } catch (e) {
    Scaffold.of(context).hideCurrentSnackBar();
  }
  try {
    scaffoldkey.currentState.showSnackBar(snackBar);
  } catch (e) {
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
