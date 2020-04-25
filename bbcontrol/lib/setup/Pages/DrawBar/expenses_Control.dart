import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class ExpensesControlPage extends StatefulWidget {

  String userId;
  ExpensesControlPage({Key key, this.userId}) : super(key: key);

  @override
  _ExpensesControlPageState createState() => _ExpensesControlPageState();
}

class _ExpensesControlPageState extends State<ExpensesControlPage> {

  bool currentOrder = false;
  bool nextOrder = false;
  List<DocumentSnapshot> orders;
  final CollectionReference _ordersCollectionReference = Firestore.instance
      .collection('Orders');

  void getCustomerOrders() async{
    await _ordersCollectionReference.where("Field.user_id", isEqualTo: widget.userId)
        .getDocuments().then((query) {
      orders = query.documents;
    });
    print('orderssss'+ '$orders');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Control'),
        backgroundColor: const Color(0xFFAD4497),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:
        ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Text('Set limit to: ',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Current order'),
                          Checkbox(
                            value: currentOrder,
                            onChanged: (bool value){
                              setState(() {
                                currentOrder = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Next order'),
                          Checkbox(
                            value: nextOrder,
                            onChanged: (bool value){
                              setState(() {
                                nextOrder = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Text('Amount: ',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: MoneyTextFormField(
                      settings: MoneyTextFormFieldSettings(
                          moneyFormatSettings: MoneyFormatSettings(
                              currencySymbol: 'IDR',
                              displayFormat: MoneyDisplayFormat.symbolOnRight),
                          appearanceSettings: AppearanceSettings(
                              padding: EdgeInsets.all(15.0),
                              labelText: 'Long Format Demo',
                              hintText: 'Custom Placeholder',
                              formattedStyle:
                              TextStyle(color: Colors.blue))),

                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
