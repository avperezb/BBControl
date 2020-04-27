import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/orders_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class ExpensesControlPage extends StatefulWidget {

  String userId;
  ExpensesControlPage({Key key, this.userId}) : super(key: key);

  @override
  _ExpensesControlPageState createState() => _ExpensesControlPageState();
}

class _ExpensesControlPageState extends State<ExpensesControlPage> {

  TextEditingController compactCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool currentOrder = false;
  bool nextOrder = false;
  bool checkBoxState = true;
  FormFieldValidator<String> validator;

  TextStyle _ts = TextStyle(fontSize: 26.0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('/Orders').where(
            'idUser', isEqualTo: widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            loaderFunction();
            setState(() {
              checkBoxState = false;
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Detail of order'),
              centerTitle: true,
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
                                Text('Current order',style: TextStyle(
                            fontSize: 18
                        ),),
                               currentOrderCB(),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Next order',style: TextStyle(
                                fontSize: 18
                            ),),
                                Checkbox(
                                  value: nextOrder,
                                  onChanged: (bool value) {
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
                      Expanded(
                        child: Container(
                          child: MoneyTextFormField(
                            settings: MoneyTextFormFieldSettings(
                                controller: compactCtrl,
                                moneyFormatSettings: MoneyFormatSettings(
                                    displayFormat:
                                    MoneyDisplayFormat.compactSymbolOnLeft),
                                appearanceSettings: AppearanceSettings(
                                    padding: EdgeInsets.all(15.0),
                                    hintText: 'Custom Placeholder',
                                    labelStyle: _ts,
                                    inputStyle: _ts.copyWith(color: Colors.orange),
                                    formattedStyle:
                                    _ts.copyWith(color: Colors.blue))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        color: const Color(0xFFAD4497),
                        onPressed: () async {

                          print(compactCtrl.text);

                        },
                        child: Text('Set limit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  currentOrderCB(){
    return Checkbox(
      value: currentOrder,
      onChanged: (bool value) {
        setState(() {
          currentOrder = value;
        });
      },
    );
  }

  Widget loaderFunction() {
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