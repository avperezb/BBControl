import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlcoholicDrinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Bacata')),);
              },
              leading: Image.asset('assets/images/polas/bacata.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Bacata'),
                    Text('4,1% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('White beer type witbier. Made with wheat and orange peels.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Cajica')),);
              },
              leading: Image.asset('assets/images/polas/cajica.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Cajica'),
                    Text('5,3% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Blonde beer type honey ale. Made with bee honey.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Candelaria')),);
              },
              leading: Image.asset('assets/images/polas/candelaria.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Candelaria'),
                    Text('5,2% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Blonde beer type kölsch. Made with pure malt.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Chapinero')),);
              },
              leading: Image.asset('assets/images/polas/chapinero.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Chapinero'),
                    Text('5,0% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Black beer type porter. Made with pure toasted malt.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Lager')),);
              },
              leading: Image.asset('assets/images/polas/lager.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Lager'),
                    Text('5,0% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Blonde beer type lager. Made with pure malt.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Macondo')),);
              },
              leading: Image.asset('assets/images/polas/macondo.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Macondo'),
                    Text('5,8% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Black beer type ale stout. Made with and infusion of Colombian coffee.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Monserrate')),);
              },
              leading: Image.asset('assets/images/polas/monserrate.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Monserrate'),
                    Text('5,0% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Red beer type bitter. Made with pure malt.'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
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
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderAlcohol('Septimazo')),);
              },
              leading: Image.asset('assets/images/polas/septimazo.png'),
              title: Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Septimazo'),
                    Text('6,0% alc',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              subtitle: Text('Red beer type india pale ale. Made with aromatic hops.'),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderAlcohol extends StatefulWidget {
  @override
  String beer;
  OrderAlcohol(String beer){
    this.beer = beer;
  }

  @override
  _OrderAlcoholState createState() => _OrderAlcoholState();
}

class _OrderAlcoholState extends State<OrderAlcohol> {
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
    };
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
            Container(
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
                        ),),
                    ),
                  )
                ],
              ),
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
            color: const Color(0xFFD7384A),
          ),
          onPressed: (){
            if(quantity > 0){
              setState(() {
                quantity --;
                widget.callback(quantity, widget.size);
              });

            }
          },
        ),
        Text(
            '$quantity',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            )
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: const Color(0xFFD7384A),
          ),
          onPressed: (){
            if(quantity < getMaxOrder(widget.size)){
              setState(() {
                quantity ++;
                widget.callback(quantity, widget.size);
              });
            }
          },
        ),
      ],
    );
  }
}


