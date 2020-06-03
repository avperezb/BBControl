import 'dart:convert';
import 'dart:io';
import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/PreOrders/preOrder.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class FoodList extends StatefulWidget {

  List<OrderItem> productsOrder = new List<OrderItem>();
  var mealPrices = '';
  List<String> mealNames = [];
  var jsonOrder = '';
  String userId;
  FoodList({userId}){
    this.userId = userId;
    getInfo();
  }

  Future<List<Map<String, dynamic>>> getInfo() async{

    QuerySnapshot alertRef = await Firestore.instance.collection('/FoodPlates').getDocuments();
    List<Map<String, dynamic>> messages = new List();

    List<DocumentSnapshot> alertSnaps= alertRef.documents;

    for (int i = 0; i < alertSnaps.length; i++) {
      mealNames.add(alertSnaps[i]['name']);
      mealPrices += '"${alertSnaps[i]['name']}": '
          '{"id": "${alertSnaps[i].documentID}", '
          '"price": ${alertSnaps[i]['price']} ,'
          '"quantity": 0},';
    }
    mealPrices = mealPrices.substring(0, mealPrices.length - 1);
    mealPrices = '{$mealPrices}';

    mealNames.forEach((drink){
      jsonOrder += '"$drink" : 0,';
    } );
    jsonOrder = jsonOrder.substring(0, jsonOrder.length - 1);
    jsonOrder = '{$jsonOrder}';
    return messages;

  }

  @override
  _FoodListState createState() => _FoodListState();

}

class _FoodListState extends State<FoodList> {
  int accumulateTotal = 0;
  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;

  callback(String mealName, int quantity){
    Map<String, dynamic> map = jsonDecode(widget.mealPrices);
    map[mealName]['quantity'] = quantity;
    setState(() {
      widget.mealPrices = json.encode(map);
      accumulateTotal = calculateTotal();
    });
  }

  int calculateTotal(){
    int total = 0;
    Map<String, dynamic> orderMap = jsonDecode(widget.mealPrices);
    widget.mealNames.forEach((meal){
      int subtotal = orderMap[meal]['price']*orderMap[meal]['quantity'];
      total += subtotal;
    });
    return total;
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(
            "/FoodPlates")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Food'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFB75BA4),
                ),
                body :
                ColorLoader5(
                  dotOneColor: Colors.redAccent,
                  dotTwoColor: Colors.blueAccent,
                  dotThreeColor: Colors.green,
                  dotType: DotType.circle,
                  dotIcon: Icon(Icons.adjust),
                  duration: Duration(seconds: 1),
                )
            );
          }
          else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Food'),
                  centerTitle: true,
                  backgroundColor: const Color(0xFFB75BA4),
                ),
                bottomSheet: Card(
                    elevation: 6.0,
                    child: Container(
                      child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          color: const Color(0xFFB75BA4),
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
                            int sumQuantity = 0;
                            jsonDecode(widget.mealPrices).forEach((name, content){
                              sumQuantity += content['quantity'];
                            });
                            if(sumQuantity > 0){
                              Navigator.push(context, MaterialPageRoute(builder: (
                                  context) => PreOrderPage(widget.mealPrices, widget.userId)),);
                            }
                            else{
                              noProductsToast();
                            }
                          }
                      ),
                    )
                ),
                body: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 90,
                        child: ListView(
                          children: snapshot.data.documents.map<SingleMeal>((DocumentSnapshot meal ){
                            return SingleMeal(meal['name'], meal['description'], meal['price'], meal['category'], callback);
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
            );
          }
        });
  }

  noProductsToast(){
    return showSimpleNotification(
      Text('No products selected',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Select the products you would like to purchase.',
        style: TextStyle(
        ),),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.white,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss',
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16
              ),));
      }),
      background: Colors.blue,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

}

class SingleMeal extends StatefulWidget {
  String mealName;
  String description;
  int price;
  String category;
  Function(String, int) callback;

  SingleMeal(String mealName, String description, int price, String category, Function callback){
    this.mealName = mealName;
    this.description = description;
    this.price = price;
    this.category = category;
    this.callback = callback;
  }

  @override
  _SingleMealState createState() => _SingleMealState();
}

class _SingleMealState extends State<SingleMeal> {
  int quantity;

  callback(int quantity){
    setState(() {
      this.quantity = quantity;
    });
    widget.callback(widget.mealName, quantity);
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
          title: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.mealName),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        // fontSize: 15
                      ),
                    ),
                  ),
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

  int quantity = 0;
  int max = 20;
  bool minDisabled = true;
  bool maxDisabled = false;
  var colorDecrease = Color(0xFF7F7F7F);
  var colorIncrease = Color(0xFFD7384A);
  final enabledColor = Color(0xFFD7384A);
  final disabledColor = Color(0xFF7F7F7F);
  @override
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

