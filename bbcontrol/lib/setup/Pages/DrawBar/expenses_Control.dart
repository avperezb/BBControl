import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:moneytextformfield/moneytextformfield.dart';


class ExpensesControlPage extends StatefulWidget {

  String userId;
  num currentAmount;
  ExpensesControlPage({@required this.userId, this.currentAmount});

  @override
  _ExpensesControlPageState createState() => _ExpensesControlPageState();
}

class _ExpensesControlPageState extends State<ExpensesControlPage> {

  CustomersFirestoreClass _customersFirestoreClass = CustomersFirestoreClass();

  FormFieldValidator<String> validator;
  bool nextOrder = false;
  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  TextStyle _ts = TextStyle(fontSize: 26.0);
  final formatterMoney = MoneyMaskedTextController();
  num newAmount;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Firestore.instance.collection('/Customers').document(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Container(
                color: Colors.white,
                child:  loaderFunction()
            );
          } else {
            widget.currentAmount = snapshot.data['limitAmount'];
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Current limit amount: ${formatCurrency.format(widget.currentAmount)}', textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 17),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Text('Set limit to your next order?',
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
                            onChanged: (value) {
                              setState(() {
                                nextOrder = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(11),
                            ],
                            keyboardType: TextInputType.number,
                            controller: formatterMoney,
                            validator: (input) {
                              String feedback;
                              if(input.isEmpty){
                                feedback = 'You didn\'t enter any amount';
                              }
                              return feedback;
                            },
                            onChanged: (input) {
                              setState(() => newAmount = formatterMoney.numberValue);
                            },
                            decoration: InputDecoration(
                              border:const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              prefixIcon: const Icon(Icons.monetization_on,
                                  color:const Color(0xFFAD4497)
                              ),
                              hintText: 'Enter amount',
                              labelText: 'Amount',
                              contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                            print(formatterMoney.numberValue );
                            print(nextOrder);
                            if (formatterMoney.numberValue >= 2500 && nextOrder){
                              setLimit(widget.userId,
                                  formatterMoney.numberValue);
                              setState(() => newAmount = formatterMoney.numberValue);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildAboutDialog2(context),
                              );
                              Navigator.pop(context);
                            }
                            else if(formatterMoney.numberValue < 2500 || !nextOrder){
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
      title: const Text('Oops! Limit must be at least \$2.500 and checkbox must be marked.'),
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