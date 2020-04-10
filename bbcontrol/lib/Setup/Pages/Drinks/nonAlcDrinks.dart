import 'dart:convert';

import 'package:flutter/material.dart';

class NonAlcoholicDrinks extends StatefulWidget {
  @override
  _NonAlcoholicDrinksState createState() => _NonAlcoholicDrinksState();
}

class _NonAlcoholicDrinksState extends State<NonAlcoholicDrinks> {
  @override
  String accumulateTotal = '\$0';
  Widget build(BuildContext context) {
    return Container(
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListView(
            children: <Widget>[
              SingleDrink('Coke'),
              SingleDrink('Mineral water'),
              SingleDrink('Capuccino'),
              SingleDrink('Latte'),
              SingleDrink('Machiatto'),
              SingleDrink('Americano'),
              SingleDrink('Classic lemonade'),
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
                        ),),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}

class SingleDrink extends StatelessWidget {
  var drinks = '{'
      '"Coke" : { "Volume" : "350 mL", "Price" : 3900, "Image" : "assets/images/nonAlcoholic/coke.png"},'
      '"Mineral water" : { "Volume" : "400 mL", "Price" : 3500, "Image" : "assets/images/nonAlcoholic/manantial.png"},'
      '"Capuccino" : { "Volume" : "", "Price" : 4500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Latte" : { "Volume" : "", "Price" : 4500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Machiatto" : { "Volume" : "", "Price" : 3500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Americano" : { "Volume" : "", "Price" : 2500, "Image" : "assets/images/nonAlcoholic/cafe.png"},'
      '"Classic lemonade" : { "Volume" : "", "Price" : 4900, "Image" : "assets/images/nonAlcoholic/lemonadeGlass.png"}'
      '}';
  String drinkName;
  callback(int quantity){

  }
  SingleDrink(String drinkName){
    this.drinkName = drinkName;
    getInfo();
  }

  String volume;
  int price;
  String image;
  void getInfo(){
    Map<String, dynamic> parsedJson = json.decode(drinks)[drinkName];
    this.volume = parsedJson['Volume'];
    this.price = parsedJson['Price'];
    this.image = parsedJson['Image'];
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
          onTap: () {},
          leading: Container(
            width: 70,
            child: Center(
              child: Image.asset(image),
            ),
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
          subtitle: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    formatPrice(price),
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                  QuantityControl(callback),
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.remove,
            color: const Color(0xFFD7384A),
          ),
          onPressed: (){
            if(quantity > 0){
              setState(() {
                quantity --;
                widget.callback(quantity);
              });

            }
          },
        ),
        Text(
            '$quantity',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            )
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: const Color(0xFFD7384A),
          ),
          onPressed: (){
            if(quantity < max){
              setState(() {
                quantity ++;
                widget.callback(quantity);
              });
            }
          },
        ),
      ],
    );
  }
}


