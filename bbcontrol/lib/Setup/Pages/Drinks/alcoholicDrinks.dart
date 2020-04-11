import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AlcoholicDrinks extends StatelessWidget {
  List<String> beers = ['Bacata', 'Cajica', 'Candelaria', 'Chapinero', 'Lager', 'Macondo', 'Monserrate', 'Septimazo'];

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ListView(
        children: beers.map((beer) => SingleBeer(beer)).toList(),
      ),
    );
  }
}

class SingleBeer extends StatelessWidget {
  var beers = '{'
      '"Bacata" : { "Volume" : "4,1% alc", "Description" : "White beer type witbier. Made with wheat and orange peels.", "Image" : "assets/images/polas/bacata.png"},'
      '"Cajica" : { "Volume" : "5,3% alc", "Description" : "Blonde beer type honey ale. Made with bee honey.", "Image" : "assets/images/polas/cajica.png"},'
      '"Candelaria" : { "Volume" : "5,2% alc", "Description" : "Blonde beer type kölsch. Made with pure malt.", "Image" : "assets/images/polas/candelaria.png"},'
      '"Chapinero" : { "Volume" : "5,0% alc", "Description" : "Black beer type porter. Made with pure toasted malt.", "Image" : "assets/images/polas/chapinero.png"},'
      '"Lager" : { "Volume" : "5,0% alc", "Description" : "Blonde beer type lager. Made with pure malt.", "Image" : "assets/images/polas/lager.png"},'
      '"Macondo" : { "Volume" : "5,8% alc", "Description" : "Black beer type ale stout. Made with and infusion of Colombian coffee.", "Image" : "assets/images/polas/macondo.png"},'
      '"Monserrate" : { "Volume" : "5,0% alc", "Description" : "Red beer type bitter. Made with pure malt.", "Image" : "assets/images/polas/monserrate.png"},'
      '"Septimazo" : { "Volume" : "6,0% alc", "Description" : "Red beer type india pale ale. Made with aromatic hops.", "Image" : "assets/images/polas/septimazo.png"}'
      '}';
  String drinkName;
  SingleBeer(String drinkName){
    this.drinkName = drinkName;
    getInfo();
  }

  String volume;
  String description;
  String image;
  void getInfo(){
    Map<String, dynamic> parsedJson = json.decode(beers)[drinkName];
    this.volume = parsedJson['Volume'];
    this.description = parsedJson['Description'];
    this.image = parsedJson['Image'];
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderBeer(drinkName)),);
          },
          leading: Image.asset(image),
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
    );;
  }
}


class OrderBeer extends StatefulWidget {
  @override
  String beer;
  OrderBeer(String beer){
    this.beer = beer;
  }

  @override
  _OrderBeerState createState() => _OrderBeerState();
}

class _OrderBeerState extends State<OrderBeer> {
  int glassTotal = 0;
  int towerTotal = 0;
  int pintTotal = 0;
  int jarTotal = 0;
  String accumulateTotal = '\$0';

  Widget build(BuildContext context) {
    var prices = '{ "Glass" : "7900", "Pint" : "11000", "Tower" : "60000", "Jar" : "34000"  }';

    int getTotalOrder(){
      var parsedJson = json.decode(prices);
      int total = glassTotal*int.parse(parsedJson['Glass']) + towerTotal*int.parse(parsedJson['Tower']) +
          pintTotal*int.parse(parsedJson['Pint']) + jarTotal*int.parse(parsedJson['Jar']);
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

    String getSizePrice(String size){
      var parsedJson = json.decode(prices);
      String price = parsedJson[size];

      return '\$' + addDecimals(price);
    }

    callback(int quantity, String size){
      setState(() {

        if(size == 'Glass') glassTotal = quantity;
        else if(size == 'Tower') towerTotal = quantity;
        else if(size == 'Pint') pintTotal = quantity;
        else if(size == 'Jar') jarTotal = quantity;

        int total = getTotalOrder();
        String aux = total.toString();
        accumulateTotal = '\$' + addDecimals(aux) ;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.beer),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
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
                        getSizePrice('Glass'),
                        style: TextStyle(
                            color: const Color(0xFFD7384A),
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
                        getSizePrice('Tower'),
                        style: TextStyle(
                            color: const Color(0xFFD7384A),
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
                        getSizePrice('Jar'),
                        style: TextStyle(
                            color: const Color(0xFFD7384A),
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
                        getSizePrice('Pint'),
                        style: TextStyle(
                            color: const Color(0xFFD7384A),
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
        )

    );
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


