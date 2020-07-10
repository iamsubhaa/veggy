import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veggy/models/index.dart';
import 'package:veggy/providers/favourite.dart';
import 'package:veggy/providers/index.dart';
import 'package:veggy/utills/index.dart';
import 'package:veggy/widgets/index.dart';

class ProductCard extends StatefulWidget {
  ProductCard({this.product});
  Product product;
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavourite = false;
  TextEditingController _textEditingController =
      TextEditingController(text: '1');
  @override
  void initState() {
    _textEditingController.text = widget.product.stock < 1 ? "0" : "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
          elevation: 0.0,
          child: Column(children: <Widget>[
            Image.network(
              BASE_URL + widget.product.image,
              fit: BoxFit.fill,
            ),
            Text(
              '${widget.product.name} - 1 ${widget.product.unit}',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '₹ ${widget.product.price}',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough),
            ),
            Text(
              '₹ ${(widget.product.price * (100 - widget.product.off) / 100).round()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: widget.product.stock < 1
                        ? null
                        : () {
                            int val = int.parse(_textEditingController.text);
                            if (val > 1) {
                              _textEditingController.text =
                                  (val - 1).toString();
                            }
                          }),
                Container(
                  height: 25,
                  width: 50,
                  child: TextField(
                    onChanged: (val) {
                      int value = int.parse(val);
                      _textEditingController.text = value > widget.product.stock
                          ? widget.product.stock.toString()
                          : value;
                      setState(() {});
                    },
                    readOnly: widget.product.stock < 1,
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
                    onPressed: widget.product.stock < 1
                        ? null
                        : () {
                            int val = int.parse(_textEditingController.text);
                            if (val < widget.product.stock) {
                              _textEditingController.text =
                                  (val + 1).toString();
                            }
                          }),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: widget.product.stock < 1 ? Colors.grey : Colors.green),
              child: FlatButton(
                disabledColor: Colors.grey,
                onPressed: widget.product.stock < 1
                    ? null
                    : () {
                        Provider.of<Cart>(context, listen: false).addCart(
                            widget.product.id, _textEditingController.text);
                        showSnackBar(context, 'Added to cart');
                      },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  widget.product.stock < 1
                      ? Container()
                      : Icon(Icons.shopping_cart, color: Colors.white),
                  Text(
                      widget.product.stock < 1
                          ? 'Out of Stock'
                          : ' Add to Cart',
                      style: TextStyle(fontSize: 15, color: Colors.white))
                ]),
              ),
            )
          ])),
      Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(
              Provider.of<Favouite>(context).fav.contains(widget.product.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  Provider.of<Favouite>(context).fav.contains(widget.product.id)
                      ? Colors.green
                      : Colors.black,
            ),
            onPressed: () {
              Provider.of<Favouite>(context, listen: false)
                  .setFav(widget.product.id);
              // setState(() {
              //   _isFavourite = !_isFavourite;
              // });
            },
          )),
      widget.product.off == 0
          ? Container()
          : Align(
              alignment: Alignment.topLeft,
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.rectangle),
                  child: Text(
                    '${widget.product.off}% off',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            )
    ]);
  }
}

class CartPlacOrderRow extends StatefulWidget {
  @override
  _CartPlacOrderRowState createState() => _CartPlacOrderRowState();
}

class _CartPlacOrderRowState extends State<CartPlacOrderRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Total: ₹ ${Provider.of<Cart>(context).money}',
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
  ProductCardLandScape({this.cartProduct});
  CartProduct cartProduct;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            ListTile(
              isThreeLine: true,
              leading: Image.network(
                BASE_URL + cartProduct.product.image,
                fit: BoxFit.fill,
              ),
              title: Text(
                '${cartProduct.product.name} - 1 ${cartProduct.product.unit} x ${cartProduct.qty}',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '₹ ${cartProduct.product.price}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough),
                  ),
                  Text(
                    '₹ ${(cartProduct.product.price * (100 - cartProduct.product.off) / 100).round()}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ]),
                SizedBox(
                  width: 10,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '₹ ${(cartProduct.product.price * (100 - cartProduct.product.off) / 100).round() * int.parse(cartProduct.qty)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ]),
              ]),
              trailing:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                IconButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeCart(cartProduct.id);
                    showSnackBar(context, 'Delete succesfully');
                  },
                  icon: Icon(Icons.delete_forever),
                )
              ]),
            ),
            Align(
                alignment: Alignment.topRight,
                child: cartProduct.product.off>0 ? Container(
                  padding:
                      EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                  decoration: BoxDecoration(color: Colors.green),
                  child: Text(
                    '${cartProduct.product.off}% off',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ):Container()),
                Align(
                alignment: Alignment.topLeft,
                child: int.parse(cartProduct.qty) < 1 ? Container(
                  padding:
                      EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                  decoration: BoxDecoration(color: Colors.red),
                  child: Text(
                    'Sold out',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ):Container())
          ],
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
  TextEditingController _editingController = new TextEditingController();
  bool _isEdit = false;
  // User _user;
  @override
  void initState() {
    super.initState();
  }

  void loggedOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouterName.AUTH_APP, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var LoginUser = Provider.of<LoginApp>(context);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(children: [
        Container(
            height: 100,
            width: 100,
            child: CircleAvatar(
                child: Text(
              LoginUser.user.username[0].toUpperCase() ?? 'V',
              style: TextStyle(fontSize: 50),
            ))),
        SizedBox(height: 10.0),
        Text(
          LoginUser.user.username ?? 'Veggy User',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        Container(
            padding: EdgeInsets.only(top: 10.0),
            height: 35,
            child: RaisedButton(
              color: Color(0xff2D3035),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
              onPressed: loggedOut,
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
                    _editingController.text = LoginUser.user.address ?? "";
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
                LoginUser.user.address ?? "",
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
