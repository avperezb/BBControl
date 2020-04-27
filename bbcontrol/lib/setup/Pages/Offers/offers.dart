import 'dart:io';

import 'package:bbcontrol/models/orderItem.dart';
import 'package:bbcontrol/setup/Database/orderItemDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';

class Offers extends StatelessWidget {
String userId;
Offers({this.userId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:  Firestore.instance.collection(
            "/Promotions").where("active", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Offers'),
                centerTitle: true,
                backgroundColor: const Color(0xFFB75ba4),
              ),
              body: Text('There are not promotions, come check later'),
            );
          }
          else {
            return  Scaffold(
              appBar: AppBar(
                title: Text('Offers'),
                centerTitle: true,
                backgroundColor: const Color(0xFFB75ba4),
              ),
              body: Container(
                child: ListView(
                  children:   snapshot.data.documents.map<SingleOffer>((DocumentSnapshot offer){
                    return new SingleOffer(snapshot: offer, userId: userId);
                  }).toList(),
                ),
              ),
            );
          }
        }
    );
  }
}

class SingleOffer extends StatelessWidget {
  DocumentSnapshot snapshot;
  String userId;
  var formatCurrency = NumberFormat.currency(symbol: '\$',decimalDigits: 0, locale: 'en_US');
  var uuid = new Uuid();
  SingleOffer({this.snapshot, this.userId});
  double contWidth = 200;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        color: Color(0xffF2D6DB),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: contWidth,
            margin: EdgeInsets.fromLTRB(0, 40, 0, 15),
            child: Text(snapshot['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Abril',
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width:  contWidth,
            child: Text(snapshot['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: contWidth,
            child: Text(formatCurrency.format(snapshot['price']),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFD27B91),
                  fontSize: 25,
                  fontFamily: 'Abril'
              ),
            ),
          ),
          FlatButton(
            child: Text('ADD TO ORDER',
              style: TextStyle(
                color: Color(0xFF89023E),
              ),
            ),
            color: Colors.transparent,
            onPressed: (){
              OrderItem oi = OrderItem.withId(uuid.v1(), snapshot['name'], 1, "", snapshot['price']);
              DatabaseItem databaseHelper = new DatabaseItem();
              databaseHelper.insertItem(oi);
              checkInternetConnection(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/Order', ModalRoute.withName('/'),arguments: userId);
            },
          )
        ],
      ),
    );
  }
  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        addedProductToast();
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
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
        color: Colors.deepPurpleAccent,);
    }, duration: Duration(milliseconds: 4000));
  }

  addedProductToast(){
    return showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.fromLTRB(
            0, 0, 0, 0),
        child: SafeArea(
          child: ListTile(
            title: Text('Offer added',
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
            subtitle: Text(
              'This offer is now in your cart.',
              style: TextStyle(fontSize: 16,
                  color: Colors.white),
            ),
            trailing: IconButton(
                icon: Icon(Icons.close,
                  color: Colors.white,),
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

