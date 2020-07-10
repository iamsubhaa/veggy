import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:veggy/models/index.dart';
import 'package:veggy/providers/favourite.dart';
import 'package:veggy/providers/index.dart';
import 'package:veggy/utills/index.dart';
import '../widgets/index.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String searchKeyword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff28292E),
        appBar: null,
        body: SafeArea(
          child: Row(children: [
            NavigationRail(
              backgroundColor: Color(0xff2D3035),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: Column(
                children: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(child: Text('S')),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                  ),
                ],
              ),
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                    icon: Icon(Icons.home),
                    selectedIcon: Icon(
                      Icons.home,
                      color: Colors.green,
                    ),
                    label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.search),
                    selectedIcon: Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
                    label: Text('Search')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.favorite),
                    label: Text('Favorite')),
                NavigationRailDestination(
                    icon: Icon(Icons.shopping_cart),
                    selectedIcon: Icon(
                      Icons.shopping_cart,
                      color: Colors.green,
                    ),
                    label: Text('Cart')),
                NavigationRailDestination(
                    icon: Icon(Icons.account_circle),
                    selectedIcon: Icon(
                      Icons.account_circle,
                      color: Colors.green,
                    ),
                    label: Text('Profile')),
              ],
            ),
            VerticalDivider(
              thickness: 1,
              width: 1,
            ),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  _selectedIndex == 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    }),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 35,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchKeyword = value;
                                      });
                                    },
                                    textInputAction: TextInputAction.search,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.green),
                                    textAlign: TextAlign.left,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Search...',
                                        // hintStyle: ,
                                        contentPadding:
                                            EdgeInsets.only(top: 10, left: 10)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.shopping_cart,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedIndex = 3;
                                          });
                                        }),
                                    Positioned(
                                      top: 0,
                                      left: 14,
                                      child: Text(
                                        Provider.of<Cart>(context).cart.length>0?Provider.of<Cart>(context).cart.length.toString():"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                }),
                            Stack(children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = 3;
                                    });
                                  }),
                              Positioned(
                                top: 1,
                                left: 19,
                                child: Text(
                                  Provider.of<Cart>(context).cart.length>0?Provider.of<Cart>(context).cart.length.toString():"",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              )
                            ]),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      title(_selectedIndex),
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: body(_selectedIndex, search: searchKeyword),
                    ),
                  ),
                ]))
          ]),
        ));
  }
}

String title(int index) {
  if (index == 0)
    return "Veggy";
  else if (index == 1)
    return "Results...";
  else if (index == 2)
    return "Favourites";
  else if (index == 3)
    return "Cart";
  else
    return "Your Profile";
}

Widget body(int index, {String search}) {
  if (index == 1)
    return ListView(children: [
      ProductTile(
        searchKeyword: search,
      )
    ]);
  else if (index == 2)
    return ListView(children: [
      ProductTile(
        isFavlist: true,
      )
    ]);
  else if (index == 3)
    return Column(children: [
      CartPlacOrderRow(),
      Expanded(child: ProductTileLandscape())
    ]);
  else if (index == 4)
    return Profile();
  else
    return ListView(children: [ProductTile()]);
}

class ProductTileLandscape extends StatefulWidget {
  @override
  _ProductTileLandscapeState createState() => _ProductTileLandscapeState();
}

class _ProductTileLandscapeState extends State<ProductTileLandscape> {
  @override
  void initState() {
    Provider.of<Cart>(context, listen: false).getCart();
    super.initState();
  }

  List<ProductCardLandScape> makeList(List<CartProduct> e) {
    List<ProductCardLandScape> temp = [];
    e.forEach((element) async {
      int available = element.product.stock - int.parse(element.qty);
      if (available >= 0) {
         temp.add(ProductCardLandScape(cartProduct: element));
      } else {
        temp.add(ProductCardLandScape(
            cartProduct: CartProduct(
                id: element.id,
                qty: element.product.stock == 0 ? "0" : element.product.stock.toString(),
                product: element.product)));
        Map body = {
          'qty': element.product.stock == 0 ? 0 : element.product.stock
        };
        final response =
            await Api().putWithToken('/carts/${element.id}/', jsonEncode(body));
      }
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: makeList(Provider.of<Cart>(context).cart)

        // [
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        //   ProductCardLandScape(),
        // ]
        );
  }
}

class ProductTile extends StatefulWidget {
  ProductTile({this.isFavlist = false, this.searchKeyword = ""});
  bool isFavlist;
  String searchKeyword;
  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  List<Product> _product = [];
  bool _isFetching = true;
  fetchProducts() async {
    try {
      final response = await Api().getWithToken('/products');
      _product = response.map((val) => Product.fromJSON(val)).toList() ?? [];
      print(_product);
    } catch (e) {
      print('Home product fetch err $e');
    }
    setState(() {
      _isFetching = false;
    });
    print('finally');
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: widget.isFavlist
            ? _product
                .where((e) => Provider.of<Favouite>(context).fav.contains(e.id))
                .toList()
                .map((e) => Container(
                    width: 155,
                    child: ProductCard(
                      product: e,
                    )))
                .toList()
            : widget.searchKeyword != ""
                ? _product
                    .where((e) => e.name.contains(widget.searchKeyword))
                    .toList()
                    .map((e) => Container(
                        width: 155,
                        child: ProductCard(
                          product: e,
                        )))
                    .toList()
                : _product
                    .map((e) => Container(
                        width: 155,
                        child: ProductCard(
                          product: e,
                        )))
                    .toList());
  }
}
