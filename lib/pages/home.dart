import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/index.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
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
                                        '999+',
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
                                  '999+',
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
                      child: body(_selectedIndex),
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

Widget body(int index) {
  if (index == 3)
    return Column(children: [
      CartPlacOrderRow(),
      Expanded(child: ProductTileLandscape())
    ]);
  else if (index == 4)
    return Profile();
  else
    return ListView(children: [ProductTile()]);
}

class ProductTileLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
      ProductCardLandScape(),
    ]);
  }
}

class ProductTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
      Container(width: 155, child: ProductCard()),
    ]);
  }
}
