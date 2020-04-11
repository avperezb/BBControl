import 'dart:convert';

import 'package:flutter/material.dart';

class FoodList extends StatefulWidget {
  List<String> mealNames = ['Transmilenio', 'Gold museum', 'Rosales', 'Cedritos', 'Andino', 'Colombian pizza', 'Margarita pizza', 'BLT - BBC'];
  var jsonOrder = '';

  void jsonString(){
    mealNames.forEach((meal){
      jsonOrder += '"$meal" : 0,';
    } );
    jsonOrder = jsonOrder.substring(0, jsonOrder.length - 1);
    jsonOrder = '{$jsonOrder}';
  }

  FoodList(){
    jsonString();
  }
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  String accumulateTotal = '\$0';

  callback(String mealName, int quantity){
    Map<String, dynamic> map = jsonDecode(widget.jsonOrder);
    map[mealName] = quantity;
    setState(() {
      widget.jsonOrder = json.encode(map);
      accumulateTotal = '\$' + addDecimals(calculateTotal().toString());
    });
  }

  int calculateTotal(){
    int total = 0;
    Map<String, dynamic> orderMap = jsonDecode(widget.jsonOrder);
    Map<String, dynamic> mealsMap = jsonDecode(meals);
    widget.mealNames.forEach((meal){
      int subtotal = orderMap[meal]*mealsMap[meal]['Price'];
      total += subtotal;
    });
    return total;
  }

  String addDecimals(String price){
    String result = "0";
    if(int.parse(price) > 0) {
      String end = price.substring(price.length - 3, price.length);
      String start = (price.length >= 4) ? price.substring(0, price.length - 3) + '.' : "";
      result = start + end;
    }
    return result;
  }

  var meals = '{'
      '"Transmilenio" : { "Description" : "Buffalo wings with blue cheese sauce and house fries.", "Price" : 21900},'
      '"Gold museum" : { "Description" : "Mixed skewers with beef, chicken and sausage, sided with house guacamole.", "Price" : 25900},'
      '"Rosales" : { "Description" : "Homemade corn tortillas sided with chicken, house guacamole and pico de gallo.", "Price" : 29900},'
      '"Cedritos" : { "Description" : "House potatos and onion rings with balsamic oil.", "Price" : 7900},'
      '"Andino" : { "Description" : "Fried plantain  with cheese, sided with shredded chicken and house guacamole.", "Price" : 21900},'
      '"Colombian pizza" : { "Description" : "Sausage, paipa cheese, fresh corn and sweet plantain.", "Price" : 24900},'
      '"Margarita pizza" : { "Description" : "Buffalo mozzarella, grilled tomatoes and fresh oregano.", "Price" : 21900},'
      '"BLT - BBC" : { "Description" : "Ciabatta bread, bacon, avocado and grilled tomatoes.", "Price" : 19900}'
      '}';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6B00),
      ),
        bottomSheet: Card(
          elevation: 6.0,
          child: Container(
            height: MediaQuery.of(context).size.height*0.1,
            child: Row(
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
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: const Color(0xFFD7384A),
                    onPressed:(){},
                    child: Text('Add order',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body : Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height*0.77,
                child: ListView(
                  children: widget.mealNames.map((meal) => SingleMeal(meal, meals, callback)).toList(),
                ),
              ),
            )
          ],
        )
    );
  }
}

class SingleMeal extends StatefulWidget {
  var meals;
  String mealName;
  String description;
  int price;
  Function(String, int) callback;

  SingleMeal(String drinkName, meals, Function callback){
    this.mealName = drinkName;
    this.meals = meals;
    this.callback = callback;
    getInfo();
  }

  void getInfo(){
    Map<String, dynamic> parsedJson = json.decode(meals)[mealName];
    this.description = parsedJson['Description'];
    this.price = parsedJson['Price'];
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
  @override
  int quantity = 0;
  int max = 4;
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


