import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class OrderAlcohol extends StatelessWidget {
  @override
  String beer;
  OrderAlcohol(String beer){
    this.beer = beer;
  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(beer),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text('Glass'),
                      Image(
                        image: AssetImage('assets/images/beerPresentations/beerGlass2.png'),
                        width: 100,
                      ),
                      Text('Volume: 330 mL'),
                      Text('Price: \$7900'),
                      QuantityControl(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

class QuantityControl extends StatefulWidget {
  @override
  _QuantityControlState createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  @override
  int quantity = 0;
  int max = 10;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: (){
            if(quantity > 0){
              setState(() {
                quantity --;
              });
            }
          },
        ),
        Text('$quantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            if(quantity < max){
              setState(() {
                quantity ++;
              });
            }
          },
        ),
      ],
    );
  }
}

