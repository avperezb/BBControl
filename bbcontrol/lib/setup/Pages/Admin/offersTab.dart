import 'dart:io';

import 'package:bbcontrol/models/offer.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/offers_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class OffersTab extends StatefulWidget {
  List<Offer> offers = new List<Offer>();
  @override
  _OffersTabState createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:  Firestore.instance.collection("/Promotions").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            return ColorLoader5();
          }
          else{
            return Scaffold(
              bottomSheet: Container(
                margin: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child:  RaisedButton(
                        onPressed: (){
                          checkInternetConnection(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: const Color(0xFFB75ba4))
                        ),
                        color: Colors.white,
                        child: Text('SAVE',
                          style: TextStyle(
                            color: const Color(0xFFB75ba4),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child:  RaisedButton(
                        onPressed: () async{
                          try {
                            final result = await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              updateSuccesfulToast();
                            }
                          } on SocketException catch (_) {
                            return connectionErrorToast();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: const Color(0xFFB75ba4))
                        ),
                        color: const Color(0xFFB75ba4),
                        child: Text('ADD',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 130,
                child: ListView(
                  children: snapshot.data.documents.map<SingleOffer>((DocumentSnapshot offer ){
                    Offer newOffer = new Offer(
                        offer.documentID, offer['active'], offer['description'], offer['name'], offer['price']
                    );
                    widget.offers.add(newOffer);
                    return SingleOffer(offer: newOffer, active: newOffer.active,);
                  }).toList(),
                ),
              ),
            );
          }
        }
    );
  }

  checkInternetConnection(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        updateSuccesfulToast();
      }
    } on SocketException catch (_) {
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Connection error",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Offers will be updated once the connection is back.',
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
      background: Colors.deepPurpleAccent,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  updateSuccesfulToast(){
    return showSimpleNotification(
      Text("Offers updated",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('The offers selected were successfully updated.',
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
      background: Colors.cyan,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  Widget loaderFunction(){
    return ColorLoader5(
      dotOneColor: Colors.redAccent,
      dotTwoColor: Colors.blueAccent,
      dotThreeColor: Colors.green,
      dotType: DotType.circle,
      dotIcon: Icon(Icons.adjust),
      duration: Duration(seconds: 2),
    );
  }
}

class SingleOffer extends StatefulWidget {
  Offer offer;
  bool active;
  SingleOffer({this.offer, this.active});

  @override
  _SingleOfferState createState() => _SingleOfferState();
}

class _SingleOfferState extends State<SingleOffer> {
  OffersFirestoreClass _offersFirestoreClass = OffersFirestoreClass();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(widget.offer.name),
              ),
              Container(
                child: Checkbox(
                  value: widget.active,
                  onChanged: (bool value){
                    _offersFirestoreClass.updateOfferStatus(widget.offer.id, value);
                    setState(() {
                      widget.active = value;
                    });
                  },
                ),
              )
            ],
          ),
          subtitle: widget.active ?
          Text('Active', style: TextStyle(color: Colors.green),) :
          Text('Inactive', style: TextStyle(color: Colors.red),)
      ),
    );
  }
}

