import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final iconSize = 60.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24.0)/6,
            child: FlatButton(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              color: const Color(0xFF69B3E7),
              onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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
    );
  }
}