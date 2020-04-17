import 'package:bbcontrol/Setup/Pages/Food/food.dart';
import 'package:bbcontrol/Setup/Pages/Reservations/reservationsList.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bbcontrol/Setup/Pages/Drinks/drinks.dart';
import 'package:overlay_support/overlay_support.dart';
import '../Services/auth.dart';


class Home extends StatelessWidget {

  AuthService _auth = AuthService();
  final iconSize = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('log out'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: ListView(
          children:<Widget>[ Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)/6,
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  color: const Color(0xFF69B3E7),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsList()),);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.group,
                          size:iconSize,
                          color: Colors.white),
                      Text('Reservations',
                        style: TextStyle(
                          color: Colors.white,
                        ) ,)
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)*4/9,
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 90.0),
                          color: const Color(0xFFD7384A),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DrinksTabs()),);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.local_bar,
                                  size: iconSize,
                                  color: Colors.white),
                              Text('Drinks',
                                style: TextStyle(
                                  color: Colors.white,
                                ) ,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)*2/9,
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                          color: const Color(0xFFFF6B00),
                          onPressed: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.directions_car,
                                  size:iconSize,
                                  color: Colors.white),
                              Text('Request cab',
                                style: TextStyle(
                                  color: Colors.white,
                                ) ,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)*2/9,
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                          color: const Color(0xFFD8AE2D),
                          onPressed: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.local_offer,
                                  size: iconSize,
                                  color: Colors.white),
                              Text('Special offers',
                                style: TextStyle(
                                  color: Colors.white,
                                ) ,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)*4/9,
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0.0, 90.0, 0.0, 90.0),
                          color: const Color(0xFF996480),
                          onPressed: () {

                            someMethod();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodList()),);
                            showSimpleNotification(
                                Text('?jjj'),
                                background: Colors.green);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.room_service,
                                  size: iconSize,
                                  color: Colors.white),
                              Text('Food',
                                style: TextStyle(
                                  color: Colors.white,
                                ) ,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)/6,
                child: FlatButton(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  color: const Color(0xFFB6B036),
                  onPressed: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.shopping_cart,
                          size: iconSize,
                          color: Colors.white),
                      Text('My order',
                        style: TextStyle(
                          color: Colors.white,
                        ) ,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      );
  }

  Future<String> someMethod ()  async{
      String mensaje = await CheckConnectivity().checkInternetConnectivity();
      return mensaje;
  }
}
