import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {

  String userId;
  MyOrdersPage({Key key, this.userId}) : super(key: key);

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {

  double iconSize = 40;
  List<DocumentSnapshot> orders;
  final CollectionReference _ordersCollectionReference = Firestore.instance
      .collection('Orders');

  void getCustomerOrders() async{
    await _ordersCollectionReference.where('user_id', isEqualTo: widget.userId)
        .getDocuments().then((query) {
      orders = query.documents;
    });
    print('orderssss'+ '${orders[0].data}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerOrders();
  }

  @override
  Widget build(BuildContext context) {
    getCustomerOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        centerTitle: true,
        backgroundColor: const Color(0xFFAD4497),
      ),
        body: Center(
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow( children: [
                      Column(children:[
                        Text('Product')
                      ]),
                      Column(children:[
                        Icon(Icons.settings, size: iconSize,),
                        Text('Settings')
                      ]),
                      Column(children:[
                        Icon(Icons.lightbulb_outline, size: iconSize,),
                        Text('Ideas')
                      ]),
                    ]),
                    TableRow( children: [
                      Icon(Icons.cake, size: iconSize,),
                      Icon(Icons.voice_chat, size: iconSize,),
                      Icon(Icons.add_location, size: iconSize,),
                    ]),
                  ],
                ),
              ),
            ]))
    );
  }
}

