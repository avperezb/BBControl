import 'dart:convert';

import 'package:bbcontrol/models/orderProduct.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/PreOrders/preOrder.dart';
import 'package:bbcontrol/setup/Pages/PreOrders/preOrderBeer.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class AlcoholicDrinks extends StatelessWidget {
  String userId;
  AlcoholicDrinks(String userId){
    this.userId = userId;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(
          "/Drinks/A1AX1eCQDVMq9uRSMnGe/Alcoholic Drinks/H6vBaPIidRlPTSFJDyAk/Beers")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ColorLoader5(
            dotOneColor: Colors.redAccent,
            dotTwoColor: Colors.blueAccent,
            dotThreeColor: Colors.green,
            dotType: DotType.circle,
            dotIcon: Icon(Icons.adjust),
            duration: Duration(seconds: 1),
          );
        }
        else {
          return Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: ListView(
              children: snapshot.data.documents.map<SingleBeer>((DocumentSnapshot beer ){
                return SingleBeer(beer, userId);
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
class SingleBeer extends StatelessWidget {

  String drinkName;
  String volume;
  String description;
  String image;
  String drinkId;
  String userId;

  SingleBeer(DocumentSnapshot beer, String userId){
    this.drinkName = beer['name'];
    this.volume = beer['volume'];
    this.description = beer['description'];
    this.image = beer['image'];
    this.drinkId = beer.documentID;
    this.userId = userId;
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Container(
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderBeer(drinkName, userId)),);
          },
          leading: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => Image.asset('assets/images/logo.png'),
            errorWidget: (context, url, error) => Image.asset('assets/images/logo.png'),
          ),
          title: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(drinkName),
                Text(volume,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                    ))
              ],
            ),
          ),
          subtitle: Text(description),
        ),
      ),
    );
  }
}

class OrderBeer extends StatefulWidget {
  @override
  String beer;
  int glassPrice = 7900;
  int towerPrice = 60000;
  int pintPrice = 11000;
  int jarPrice = 34000;
  List<OrderProduct> productsList;
  String userId;

  OrderBeer(String beer, String userId){
    this.beer = beer;
    this.userId = userId;
    this.productsList = new List<OrderProduct>();
  }

  @override
  _OrderBeerState createState() => _OrderBeerState();
}

class _OrderBeerState extends State<OrderBeer> {
  var order;
  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  int glassTotal = 0;
  int towerTotal = 0;
  int pintTotal = 0;
  int jarTotal = 0;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  String accumulateTotal = '\$0';
  int getTotalOrder(){
    int total = glassTotal*widget.glassPrice + towerTotal*widget.towerPrice +
        pintTotal*widget.pintPrice + jarTotal*widget.jarPrice;
    return total;
  }

  callback(int quantity, String size){
    setState(() {

      if(size == 'Glass') glassTotal = quantity;
      else if(size == 'Tower') towerTotal = quantity;
      else if(size == 'Pint') pintTotal = quantity;
      else if(size == 'Jar') jarTotal = quantity;

      int total = getTotalOrder();
      accumulateTotal = formatCurrency.format(total);
    });
  }
  Widget build(BuildContext context) {
    order =
    '{"${widget.beer}" : {'
        '"jar" : {"quantity": $jarTotal, "price": ${widget.jarPrice}},'
        '"glass" : {"quantity": $glassTotal, "price": ${widget.glassPrice}}, '
        '"pint" : {"quantity": $pintTotal, "price": ${widget.pintPrice}},'
        '"tower" : {"quantity": $towerTotal, "price": ${widget.towerPrice}}'
        '}}';
    print(jsonDecode(order));
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.beer),
          centerTitle: true,
          backgroundColor: const Color(0xFFD7384A),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: 150,
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              'GLASS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          Text(
                            '(330 ML)',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: Image(
                          image: AssetImage('assets/images/beerPresentations/beerGlass2.png'),
                        ),
                      ),
                      Text(
                        formatCurrency.format(widget.glassPrice),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20
                        ),
                      ),
                      QuantityControl('Glass', callback),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: 150,
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              'TOWER',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          Text(
                            '(3 L)',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: Image(
                          image: AssetImage('assets/images/beerPresentations/beerTower2.png'),
                        ),
                      ),
                      Text(
                        formatCurrency.format(widget.towerPrice),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20
                        ),
                      ),
                      QuantityControl('Tower', callback),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: 150,
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              'JAR',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          Text(
                            '(1.5 L)',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: Image(
                          image: AssetImage('assets/images/beerPresentations/beerJar2.png'),
                        ),
                      ),
                      Text(
                        formatCurrency.format(widget.jarPrice),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20
                        ),
                      ),
                      QuantityControl('Jar', callback),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: 150,
                  height: 220,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              'PINT',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )
                          ),
                          Text(
                            '(570 ML)',
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                        child: Image(
                          image: AssetImage('assets/images/beerPresentations/beerPint2.png'),
                        ),
                      ),
                      Text(
                        formatCurrency.format(widget.pintPrice),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20
                        ),
                      ),
                      QuantityControl('Pint', callback),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.35,
                  child: Text(
                    'Total: $accumulateTotal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.55,
                  child: Builder(
                    builder: (context) => RaisedButton(
                      padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xFFD7384A),
                      onPressed:(){
                        getConnState(context);
                        if(!cStatus) {
                          noConnectionToast();
                        }
                        if (jarTotal!=0 || glassTotal != 0 || towerTotal != 0 || pintTotal != 0){
                          print(jsonDecode(order));
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => PreOrderBeer(order, widget.userId)),
                          );
                        }
                        else{
                          noProductsToast();
                        }
                      },
                      child: Text('Add to order',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),),
                    ),
                  ),
                )
              ],
            ),
          ],
        )

    );
  }
  noProductsToast(){
    return  showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('No products selected',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'Select the products you would like to purchase.',
              style: TextStyle(
                  fontSize: 16, color: Colors.white),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.close, color: Colors.white,),
                onPressed: () {
                  OverlaySupportEntry.of(context)
                      .dismiss();
                }),
          ),
        ),
        color: Colors.blue,);
    }, duration: Duration(milliseconds: 4000));
  }

  noConnectionToast(){
    return showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('Connection Error',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'Products will be added when connection is back.',
              style: TextStyle(
                  fontSize: 16, color: Colors.white),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.close, color: Colors.white,),
                onPressed: () {
                  OverlaySupportEntry.of(context)
                      .dismiss();
                }),
          ),
        ),
        color: Colors.blueGrey,);
    }, duration: Duration(milliseconds: 4000));
  }

  void getConnState(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }
}

class QuantityControl extends StatefulWidget  {
  @override
  String size;
  Function(int, String) callback;
  QuantityControl(String size, Function callback){
    this.size = size;
    this.callback = callback;
  }
  _QuantityControlState createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  @override
  int quantity = 0;
  bool minDisabled = true;
  bool maxDisabled = false;
  var colorDecrease = Color(0xFF7F7F7F);
  var colorIncrease = Color(0xFFD7384A);
  final enabledColor = Color(0xFFD7384A);
  final disabledColor = Color(0xFF7F7F7F);

  int getMaxOrder(String size){
    var jsonData = '{ "Glass" : "10", "Pint" : "10", "Tower" : "2", "Jar" : "3"  }';
    var parsedJson = json.decode(jsonData);
    return num.parse(parsedJson[size]);
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove,
            color: colorDecrease,
          ),
          onPressed: (){
            if(quantity == 0){
              setState(() {
                minDisabled = true;
              });
            }
            else{
              setState(() {
                quantity --;
                minDisabled = (quantity > 0) ? false : true;
                widget.callback(quantity, widget.size);
              });
            }
            if(maxDisabled){
              maxDisabled = false;
              colorIncrease = enabledColor;
            }
            colorDecrease = (minDisabled) ? disabledColor : enabledColor;
          },
        ),
        Container(
          width: 25,
          child: Center(
            child: Text(
                '$quantity',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                )
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: colorIncrease,
          ),
          onPressed: (){
            if(quantity == getMaxOrder(widget.size)){
              setState(() {
                maxDisabled = true;
              });
            }
            else{
              setState(() {
                quantity ++;
                maxDisabled = (quantity == getMaxOrder(widget.size)) ? true : false;
                widget.callback(quantity, widget.size);
              });

              if(minDisabled){
                setState(() {
                  minDisabled = false;
                  colorDecrease = enabledColor;
                });
              }
              colorIncrease = (maxDisabled) ? disabledColor : enabledColor;
            }
          },
        ),
      ],
    );
  }
}



