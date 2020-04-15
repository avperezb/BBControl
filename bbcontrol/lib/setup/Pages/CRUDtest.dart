
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Drinks/alcoholicDrinks.dart';

class Crud extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var Firestore;
    return StreamBuilder(
      stream: Firestore.instance.collection("/Drinks/A1AX1eCQDVMq9uRSMnGe/Alcoholic Drinks/H6vBaPIidRlPTSFJDyAk/Beers").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text('Loading data... wait a minute');
        }
        else{
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderBeer(snapshot.data.documents[0]['name'])),);
                },
                leading: Image.network(snapshot.data.documents[0]['image']),
                title: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(snapshot.data.documents[0]['name']),
                      Text(snapshot.data.documents[0]['volume'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                ),
                subtitle: Text(snapshot.data.documents[0]['description']),
              ),
            ),
          );
        }
      },
      );
  }

  void createRecord(){

  }

  void getData() {
  }

  void updateRecord() {
  }

  void deleteRecord() {

  }

}
