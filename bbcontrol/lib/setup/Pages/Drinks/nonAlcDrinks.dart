import 'dart:convert';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/PreOrders/preOrder.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class NonAlcoholicDrinks extends StatefulWidget {
  var drinkPrices = '';
  List<String> drinkNames = [];
  var jsonOrder = '';
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  String userEmail;

  Future<List<Map<String, dynamic>>> getInfo() async{

    QuerySnapshot alertRef = await Firestore.instance.collection('/Drinks/A1AX1eCQDVMq9uRSMnGe/Non-alcoholic Drinks').getDocuments();
    List<Map<String, dynamic>> messages = new List();

    List<DocumentSnapshot> alertSnaps= alertRef.documents;

    for (int i = 0; i < alertSnaps.length; i++) {
      drinkNames.add(alertSnaps[i]['name']);
      drinkPrices += '"${alertSnaps[i]['name']}": '
          '{"id": "${alertSnaps[i].documentID}", '
          '"price": ${alertSnaps[i]['price']} ,'
          '"quantity": 0},';
    }
    drinkPrices = drinkPrices.substring(0, drinkPrices.length - 1);
    drinkPrices = '{$drinkPrices}';

    drinkNames.forEach((drink){
      jsonOrder += '"$drink" : 0,';
    } );
    jsonOrder = jsonOrder.substring(0, jsonOrder.length - 1);
    jsonOrder = '{$jsonOrder}';
    print(drinkPrices);
    return messages;

  }

  NonAlcoholicDrinks(String userEmail){
    this.userEmail = userEmail;
    getInfo();
  }

  _NonAlcoholicDrinksState createState() => _NonAlcoholicDrinksState();
}

class _NonAlcoholicDrinksState extends State<NonAlcoholicDrinks> {
  int accumulateTotal = 0;
  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;

  callback(String drinkName, int quantity){
    Map<String, dynamic> map = jsonDecode(widget.drinkPrices);
    map[drinkName]['quantity'] = quantity;
    setState(() {
      widget.drinkPrices = json.encode(map);
      accumulateTotal = calculateTotal();
    });
  }

  int calculateTotal(){
    int total = 0;
    Map<String, dynamic> drinksMap = jsonDecode(widget.drinkPrices);
    widget.drinkNames.forEach((drink){
      int subtotal = drinksMap[drink]['price']*drinksMap[drink]['quantity'];
      total += subtotal;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(
          "/Drinks/A1AX1eCQDVMq9uRSMnGe/Non-alcoholic Drinks")
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
          return Scaffold(
              bottomSheet: Card(
                  elevation: 6.0,
                  child: Container(
                    child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: const Color(0xFFD7384A),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround,
                          children: <Widget>[
                            Text('Add to order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                            Container(
                              width: 120,
                              padding: EdgeInsets.fromLTRB(
                                  20, 10, 20, 10),
                              margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15))
                              ),
                              child: Text(
                                formatCurrency.format(accumulateTotal),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showToast(context);
                          if(!cStatus) {
                            showOverlayNotification((context) {
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
                          int sumQuantity = 0;
                          jsonDecode(widget.drinkPrices).forEach((name, content){
                            sumQuantity += content['quantity'];
                          });

                          print(sumQuantity);
                          if(sumQuantity > 0){
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) => PreOrderPage(widget.drinkPrices, widget.userEmail)),);
                          }
                          else{
                            showOverlayNotification((context) {
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
                        }
                    ),
                  )
              ),
              body : Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.66,
                      child: ListView(
                        children: snapshot.data.documents.map<SingleDrink>((DocumentSnapshot drink ){
                          return SingleDrink(drink['name'], drink['price'], drink['image'], callback);
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )
          );
        }
      },
    );
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }
}

class SingleDrink extends StatefulWidget {
  String drinkName;
  int price;
  String image;
  Function(String, int) callback;

  SingleDrink(String drinkName, int price, String image, Function callback){
    this.price = price;
    this.image = image;
    this.drinkName = drinkName;
    this.callback = callback;
  }

  @override
  _SingleDrinkState createState() => _SingleDrinkState();
}

class _SingleDrinkState extends State<SingleDrink> {
  int quantity;

  callback(int quantity){
    setState(() {
      this.quantity = quantity;
    });
    widget.callback(widget.drinkName, quantity);
  }

  String formatPrice(int price){
    String result = '0';
    String str = price.toString();
    if(price > 0) {
      String end = str.substring(str.length - 3, str.length);
      String start = (str.length >= 4) ? str.substring(0, str.length - 3) + '.' : "";
      result = start + end;
    }
    return '\$' + result;
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
          leading: Container(
            width: 70,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.image,
                placeholder: (context, url) => Image.asset('assets/images/logo.png'),
                errorWidget: (context, url, error) => Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
          title: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.drinkName),
                Text(formatPrice(widget.price),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                    ))
              ],
            ),
          ),
          subtitle: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  QuantityControl(callback)
                ],
              )
          ),
        ),
      ),
    );
  }
}

class QuantityControl extends StatefulWidget  {
  @override
  Function(int) callback;
  QuantityControl(Function callback){
    this.callback = callback;
  }
  _QuantityControlState createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  @override
  int quantity = 0;
  int max = 10;
  bool minDisabled = true;
  bool maxDisabled = false;
  var colorDecrease = Color(0xFF7F7F7F);
  var colorIncrease = Color(0xFFD7384A);
  final enabledColor = Color(0xFFD7384A);
  final disabledColor = Color(0xFF7F7F7F);

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
                widget.callback(quantity);
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
                    fontSize: 18,
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
            if(quantity == max){
              setState(() {
                maxDisabled = true;
              });
            }
            else{
              setState(() {
                quantity ++;
                maxDisabled = (quantity == max) ? true : false;
                widget.callback(quantity);
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
