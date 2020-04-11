import 'dart:convert';

import 'package:flutter/material.dart';

class NonAlcoholicDrinks extends StatefulWidget {
  List<String> drinkNames = ['Coke', 'Mineral water', 'Capuccino', 'Latte', 'Machiatto', 'Americano', 'Classic lemonade'];
  var jsonOrder = '';

  void jsonString(){
    drinkNames.forEach((drink){
      jsonOrder += '"$drink" : 0,';
    } );
    jsonOrder = jsonOrder.substring(0, jsonOrder.length - 1);
    jsonOrder = '{$jsonOrder}';
  }

  NonAlcoholicDrinks(){
    jsonString();
  }
  @override
  _NonAlcoholicDrinksState createState() => _NonAlcoholicDrinksState();
}

class _NonAlcoholicDrinksState extends State<NonAlcoholicDrinks> {
  @override
  String accumulateTotal = '\$0';

  callback(String drinkName, int quantity){
    Map<String, dynamic> map = jsonDecode(widget.jsonOrder);
    map[drinkName] = quantity;
    setState(() {
      widget.jsonOrder = json.encode(map);
      accumulateTotal = '\$' + addDecimals(calculateTotal().toString());
    });
  }

  int calculateTotal(){
    int total = 0;
    Map<String, dynamic> orderMap = jsonDecode(widget.jsonOrder);
    Map<String, dynamic> drinksMap = jsonDecode(drinks);
    widget.drinkNames.forEach((drink){
      int subtotal = orderMap[drink]*drinksMap[drink]['Price'];
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

  var drinks = '{'
      '"Coke" : { "Volume" : "350 mL", "Price" : 3900, "Image" : "assets/images/nonAlcoholic/coke.png"},'
      '"Mineral water" : { "Volume" : "400 mL", "Price" : 3500, "Image" : "assets/images/nonAlcoholic/manantial.png"},'
      '"Capuccino" : { "Volume" : "", "Price" : 4500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Latte" : { "Volume" : "", "Price" : 4500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Machiatto" : { "Volume" : "", "Price" : 3500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Americano" : { "Volume" : "", "Price" : 2500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Classic lemonade" : { "Volume" : "", "Price" : 4900, "Image" : "assets/images/nonAlcoholic/lemonadeGlass.png"}'
      '}';

  Widget build(BuildContext context) {
    return Scaffold(
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
                height: MediaQuery.of(context).size.height*0.66,
                child: ListView(
                  children: widget.drinkNames.map((drink) => SingleDrink(drink, drinks, callback)).toList(),
                ),
              ),
            )
          ],
        )
    );
  }
}

class SingleDrink extends StatefulWidget {
  var drinks;
  String drinkName;
  String volume;
  int price;
  String image;
  Function(String, int) callback;

  SingleDrink(String drinkName, drinks, Function callback){
    this.drinkName = drinkName;
    this.drinks = drinks;
    this.callback = callback;
    getInfo();
  }

  void getInfo(){
    Map<String, dynamic> parsedJson = json.decode(drinks)[drinkName];
    this.volume = parsedJson['Volume'];
    this.price = parsedJson['Price'];
    this.image = parsedJson['Image'];
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
              child: Image.asset(widget.image),
            ),
          ),
          title: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.drinkName),
                Text(widget.volume,
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
                  Text(
                    formatPrice(widget.price),
                    style: TextStyle(
                        fontSize: 17
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


