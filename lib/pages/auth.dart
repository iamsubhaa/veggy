import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/providers/favourite.dart';
import 'package:veggy/providers/index.dart';
import 'package:veggy/utills/index.dart';
import 'package:veggy/widgets/index.dart';

enum gender { Male, Female }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  String _email;
  String _password;
  String _displayName;
  String _address;
  bool _obsecure = false;
  gender _gender = gender.Male;
  String _pin = "";

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    void initState() {
      super.initState();
    }

    //GO logo widget
    Widget logo() {
      return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    width: 150,
                    height: 150,
                  ),
                ),
                height: 154,
              )),
              Positioned(
                child: Container(
                    height: 154,
                    child: Align(
                      child: Text(
                        "Veggy",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.height * 0.046,
                right: MediaQuery.of(context).size.width * 0.22,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.32,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //input widget
    Widget _input(Icon icon, String hint, TextEditingController controller,
        bool obsecure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obsecure,
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              prefixIcon: Padding(
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).primaryColor),
                  child: icon,
                ),
                padding: EdgeInsets.only(left: 30, right: 10),
              )),
        ),
      );
    }

    //button widget
    Widget _button(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, void function()) {
      return RaisedButton(
        highlightElevation: 0.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 0.0,
        color: fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    //login and register fuctions
    void isLoggedIn(indentifier, password) async {
      Map<String, dynamic> body = {
        "identifier": indentifier,
        "password": password,
      };
      try {
        final response = await Api().login('/auth/local', body);
        try {
          String msg = response['message'][0]['messages'][0]['message'];
          showSnackBar(context, msg, scaffoldkey: _scaffoldKey);
        } catch (e) {
          print('login err $e');
          String id = response['user']['id'].toString();
          String email = response['user']['email'];
          String username = response['user']['username'];
          String gender = response['user']['gender']; 
          String address = response['user']['address'];
          Provider.of<LoginApp>(context,listen: false).setUser(id, username, email, gender, address);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt', response['jwt']);
          await prefs.setString('userId', id);
          await prefs.setString('email', email);
          await prefs.setString('username', username);
          await prefs.setString('address', address);
          await prefs.setString('gender', gender);
          await prefs.setBool("loggedIn", true);
          Provider.of<Favouite>(context,listen: false).getFav(id);
          showSnackBar(context, 'Login successfull', scaffoldkey: _scaffoldKey);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouterName.MAIN_APP, (route) => false);
        }
      } catch (e) {
        print('login err $e');
      }
    }

    void _loginUser() {
      _email = _emailController.text;
      _password = _passwordController.text;
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if(_email==""){
        showSnackBar(context, "Can't blank Email", scaffoldkey: _scaffoldKey);
        return;
      }
      if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
        showSnackBar(context, "Enter valid Email", scaffoldkey: _scaffoldKey);
        return;
      }
      if(_password==""){
        showSnackBar(context, "Can't blank Password", scaffoldkey: _scaffoldKey);
        return;
      }
      // _emailController.clear();
      // _passwordController.clear();
      isLoggedIn(_email, _password);
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(RouterName.MAIN_APP, (route) => false);
    }

    void _loginSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _emailController.clear();
                              _passwordController.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 60),
                          child: _input(Icon(Icons.email), "EMAIL",
                              _emailController, false),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _input(Icon(Icons.lock), "PASSWORD",
                              _passwordController, true),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            child: _button("LOGIN", Colors.white, primary,
                                primary, Colors.white, _loginUser),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    void _finalRegister() {
      _pin = "";
      Navigator.of(context).pop();
      _loginSheet();
    }

    void _otpSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return StatefulBuilder(
            builder: (cntxt, setState) => DecoratedBox(
                  decoration:
                      BoxDecoration(color: Theme.of(context).canvasColor),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    child: Container(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _emailController.clear();
                                      _passwordController.clear();
                                      _nameController.clear();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 30.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            height: 50,
                            width: 50,
                          ),
                          SingleChildScrollView(
                            child: Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: Align(
                                        child: Container(
                                          width: 130,
                                          height: 130,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: 25, right: 40),
                                        child: Text(
                                          "OTP",
                                          style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      child: Align(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 40, left: 28),
                                          width: 130,
                                          child: Text(
                                            "Verify",
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 100, bottom: 60),
                                child: PinEntryTextField(
                                  isTextObscure: true,
                                  showFieldAsBox: true,
                                  onSubmit: (String pin) {
                                    setState(() {
                                      _pin = pin;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  child: _button(
                                      "Submit",
                                      Colors.white,
                                      primary,
                                      primary,
                                      Colors.white,
                                      _finalRegister),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height / 1.1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ),
                ));
      });
    }

    void isRegistered() async {
      Map<String, dynamic> body = {
        "username": _displayName,
        "email": _email,
        "password": _password,
        "gender": _gender.index == 0 ? 'Male' : 'Female',
        "address": _address,
      };
      try {
        final response = await Api().post('/auth/local/register', body);
        try {
          String msg = response['message'][0]['messages'][0]['message'];
          showSnackBar(context, msg, scaffoldkey: _scaffoldKey);
        } catch (e) {
          Navigator.of(context).pop();
          _loginSheet();
          showSnackBar(context, 'Registered. Please confirm email before login', scaffoldkey: _scaffoldKey);
        }
      } catch (e) {
        print('register err $e');
      }
    }

    void _registerUser() {
      _email = _emailController.text;
      _password = _passwordController.text;
      _displayName = _nameController.text;
      _address = _addressController.text;
      // _emailController.clear();
      // _passwordController.clear();
      // _nameController.clear();
      _scaffoldKey.currentState.hideCurrentSnackBar();
      if(_displayName==""){
        showSnackBar(context, "Can't blank Name", scaffoldkey: _scaffoldKey);
        return;
      }
      if(_email==""){
        showSnackBar(context, "Can't blank Email", scaffoldkey: _scaffoldKey);
        return;
      }
      if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)){
        showSnackBar(context, "Enter valid Email", scaffoldkey: _scaffoldKey);
        return;
      }
      if(_address==""){
        showSnackBar(context, "Can't blank Address", scaffoldkey: _scaffoldKey);
        return;
      }
      if(_password==""){
        showSnackBar(context, "Can't blank Password", scaffoldkey: _scaffoldKey);
        return;
      }
      if(_password.length<8){
        showSnackBar(context, "Password more than 7 digit", scaffoldkey: _scaffoldKey);
        return;
      }
      isRegistered();
      // Navigator.of(context).pop();
      // _loginSheet();
      // _otpSheet();
    }

    void _registerSheet() {
      _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
        return StatefulBuilder(
            builder: (cntxt, setState) => DecoratedBox(
                  decoration:
                      BoxDecoration(color: Theme.of(context).canvasColor),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    child: Container(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _emailController.clear();
                                      _passwordController.clear();
                                      _nameController.clear();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 30.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            height: 50,
                            width: 50,
                          ),
                          SingleChildScrollView(
                            child: Column(children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 140,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: Align(
                                        child: Container(
                                          width: 130,
                                          height: 130,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: 25, right: 40),
                                        child: Text(
                                          "REGI",
                                          style: TextStyle(
                                            fontSize: 44,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    Positioned(
                                      child: Align(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 40, left: 28),
                                          width: 130,
                                          child: Text(
                                            "STER",
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 38.0, bottom: 4, top: 60),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                          value: gender.Male,
                                          groupValue: _gender,
                                          onChanged: (val) {
                                            setState(() {
                                              _gender = val;
                                            });
                                          }),
                                      Text(
                                        'MR.',
                                        style: TextStyle(
                                            color: _gender.index == 1
                                                ? Colors.grey
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Radio(
                                          value: gender.Female,
                                          groupValue: _gender,
                                          onChanged: (val) {
                                            setState(() {
                                              _gender = val;
                                            });
                                          }),
                                      Text(
                                        'MS.',
                                        style: TextStyle(
                                            color: _gender.index == 0
                                                ? Colors.grey
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                  // top: 60,
                                ),
                                child: _input(Icon(Icons.account_circle),
                                    "DISPLAY NAME", _nameController, false),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: _input(Icon(Icons.email), "EMAIL",
                                    _emailController, false),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: _input(Icon(Icons.home), "DELIVERY ADDRESS",
                                    _addressController, false),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: _input(Icon(Icons.lock), "PASSWORD",
                                    _passwordController, true),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  child: _button(
                                      "REGISTER",
                                      Colors.white,
                                      primary,
                                      primary,
                                      Colors.white,
                                      _registerUser),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height / 1.1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ),
                ));
      });
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Color(0xff28292E),
        body: Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Container(
                child: _button("LOGIN", primary, Colors.white, Colors.white,
                    primary, _loginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: OutlineButton(
                  highlightedBorderColor: Colors.white,
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  highlightElevation: 0.0,
                  splashColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: () {
                    _registerSheet();
                  },
                ),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }
}
