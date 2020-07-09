import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/main.dart';
import 'package:veggy/utills/index.dart';

class ProductCard extends StatefulWidget {
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavourite = false;
  TextEditingController _textEditingController =
      TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
          elevation: 0.0,
          child: Column(children: <Widget>[
            Image.asset(
              "assets/images/broccoli.jpg",
              fit: BoxFit.fill,
            ),
            Text(
              'Brocolli - 1 Kg',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '₹ 120',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough),
            ),
            Text(
              '₹ 108',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      int val = int.parse(_textEditingController.text);
                      if (val > 1) {
                        _textEditingController.text = (val - 1).toString();
                      }
                    }),
                Container(
                  height: 25,
                  width: 50,
                  child: TextField(
                    style: TextStyle(fontSize: 15),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    textAlign: TextAlign.center,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      int val = int.parse(_textEditingController.text);
                      if (val < 999) {
                        _textEditingController.text = (val + 1).toString();
                      }
                    }),
              ],
            ),
            Container(
              decoration: BoxDecoration(color: Colors.green),
              child: FlatButton(
                onPressed: null,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_cart, color: Colors.white),
                  Text(' Add to Cart',
                      style: TextStyle(fontSize: 15, color: Colors.white))
                ]),
              ),
            )
          ])),
      Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(
              _isFavourite ? Icons.favorite : Icons.favorite_border,
              color: _isFavourite ? Colors.green : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isFavourite = !_isFavourite;
              });
            },
          )),
      Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.all(5),
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.rectangle),
            child: Text(
              '10% off',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      )
    ]);
  }
}

class CartPlacOrderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Total: ₹ 1000000',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        RaisedButton(
            color: Color(0xff2D3035),
            onPressed: () {},
            child: Text(
              'Place Order',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ))
      ],
    );
  }
}

class ProductCardLandScape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: ListTile(
          isThreeLine: true,
          leading: Image.asset(
            "assets/images/broccoli.jpg",
            fit: BoxFit.fill,
          ),
          title: Text(
            'Brocolli - 1 Kg x 4',
            style: TextStyle(fontSize: 15),
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '₹ 120',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough),
            ),
            Text(
              '₹ 108',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ]),
          trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '10% off',
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  '₹ 432',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ]),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _editingController =
      new TextEditingController(text: 'Mandirbazer,dantan,paschim medinipur');
  bool _isEdit = false;

  void loggedOut()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("loggedIn");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouterName.AUTH_APP, (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(children: [
        Container(
            height: 100,
            width: 100,
            child: CircleAvatar(
                child: Text(
              'S',
              style: TextStyle(fontSize: 50),
            ))),
        SizedBox(height: 10.0),
        Text(
          'Subhajit Dey',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Container(
          padding: EdgeInsets.only(top:10.0),
            height: 35,
            child: RaisedButton(
              color: Color(0xff2D3035),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
              onPressed:loggedOut,
            )),
        SizedBox(height: 15.0),
        Row(children: [
          Text(
            'Address',
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
          Container(
            height: 35,
            child: IconButton(
                padding: EdgeInsets.all(0),
                iconSize: 20,
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEdit = true;
                  });
                }),
          )
        ]),
        _isEdit
            ? Column(children: [
                TextField(
                  controller: _editingController,
                  autofocus: true,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                RaisedButton(
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  onPressed: () {
                    setState(() {
                      _isEdit = false;
                    });
                  },
                )
              ])
            : Text(
                'Mandirbazer,dantan,paschim medinipur',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Placed Orders',
          style: TextStyle(color: Colors.green, fontSize: 15),
        ),
        SizedBox(height: 8),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.black,
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
              ProductPlacedOrder(),
            ],
          ),
        )
      ]),
    );
  }
}

class ProductPlacedOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListTile(
            isThreeLine: true,
            leading: Image.asset(
              "assets/images/broccoli.jpg",
              fit: BoxFit.fill,
            ),
            title: Text('Brocoli + 4'),
            subtitle: Text(
              'Total: ₹ 108',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: RichText(
                text: TextSpan(
                    text: '15-jan-2010\n',
                    style: TextStyle(color: Colors.black),
                    children: [
                  TextSpan(
                      text: 'Delivered',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))
                ])),
          )),
    );
  }
}
