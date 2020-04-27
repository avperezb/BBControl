import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
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

  CustomersFirestoreClass _customersFirestoreClass = CustomersFirestoreClass();
  TextEditingController compactCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool currentOrder = false;
  bool nextOrder = false;
  bool checkBoxState = true;
  FormFieldValidator<String> validator;
  num currentAmount = 0;

  TextStyle _ts = TextStyle(fontSize: 26.0);

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    print(widget.userId);
    return StreamBuilder(
        stream: Firestore.instance.collection('/Customers').document(widget.userId).snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            snapshot.data['firstName'];
            snapshot.data['limitAmount'];
            currentAmount = snapshot.data['limitAmount'];
            return Scaffold(
              appBar: AppBar(
                title: Text('Expenses control'),
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
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Text('Set limit to your next order: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Checkbox(
                            value: nextOrder,
                            onChanged: (bool value) {
                              setState(() {
                                nextOrder = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Current limit amount: ${currentAmount}', textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 17),)
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
                                      hintText: 'Enter value',
                                      labelStyle: _ts,
                                      inputStyle: _ts.copyWith(
                                          color: Colors.orange),
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
                            if (compactCtrl.text != '0.0'){
                              setLimit(widget.userId,
                                  num.parse(compactCtrl.text));
                              updateAmount(num.parse(compactCtrl.text));
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildAboutDialog2(context),
                              );
                            }
                            else if(compactCtrl.text == '0.0' || !currentOrder){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildAboutDialog(context),
                              );
                            }
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Expenses control'),
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
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Text('Set limit to your next order: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Checkbox(
                            value: nextOrder,
                            onChanged: (bool value) {
                              setState(() {
                                nextOrder = value;
                              });
                            },
                          ),
                        ),
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
                                      hintText: 'Enter value',
                                      labelStyle: _ts,
                                      inputStyle: _ts.copyWith(
                                          color: Colors.orange),
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
                            if (compactCtrl.text != '' ||
                                compactCtrl.text != null) {
                              setLimit(widget.userId,
                                  num.parse(compactCtrl.text));
                            }
                            else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildAboutDialog(context),
                              );
                            }
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
        }
    );
  }

  void updateAmount(num newAmount){
    setState(() {
      currentAmount = newAmount;
    });
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

  void setLimit(String userId, num amount) {
    _customersFirestoreClass.setLimitAmount(userId, amount);
  }

  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Oops! Limit must be greater than 0 and checkbox must be marked.'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Okay, got it'),
        ),
      ],
    );
  }

  Widget _buildAboutDialog2(BuildContext context) {
    return new AlertDialog(
      title: const Text('The limit has been set!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAboutText(),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Okay, got it'),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text: 'You set a limit for the expenses control. If you have changed your mind go to settings and change it!',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
        ],
      ),
    );
  }
}