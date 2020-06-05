import 'dart:io';

import 'package:age/age.dart';
import 'package:bbcontrol/models/offer.dart';
import 'package:bbcontrol/setup/Pages/Authenticate/log_in.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/offers_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:uuid/uuid.dart';

class CreateOffer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<CreateOffer>{

  bool _active = true;
  String _description;
  String _name;
  num _price;
  var uuid = new Uuid();
  var formatCurrency = NumberFormat.currency(
      symbol: '\$', decimalDigits: 0, locale: 'en_US');
  final formatterMoney = MoneyMaskedTextController();
  OffersFirestoreClass _offersFirestoreClass = OffersFirestoreClass();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        title: Text('New offer',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFFAD4497),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 24,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextFormField(
                    validator: (input){
                      String feedback;
                      if(input.isEmpty){
                        feedback = 'Please type a name';
                      }
                      if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                        feedback = 'This field cannot contain numbers or special characters';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    onSaved: (input) => _name = input,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.local_offer,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter the offer\'s name',
                      labelText: 'Offer name',
                    ),
                    maxLength: 20,
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextFormField(
                    validator: (input){
                      String feedback;
                      if(input.isEmpty){
                        feedback = 'Please type a description';
                      }
                      if(input.isNotEmpty && !RegExp(r'[a-zA-Z0-9_]$').hasMatch(input)){
                        feedback =  'This field cannot contain special characters';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    onSaved: (input) => _description = input,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.info,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter a description',
                      labelText: 'Description',
                    ),
                    maxLength: 60,
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: TextFormField(
                  inputFormatters:[
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.number,
                  controller: formatterMoney,
                  validator: (input) {
                    String feedback;
                    if(input.isEmpty){
                      feedback = 'You didn\'t enter a price';
                    }
                    else if(formatterMoney.numberValue < 5000){
                      feedback = 'Price must be higher than \$5000';
                    }
                    return feedback;
                  },
                  onSaved: (input) => _price = formatterMoney.numberValue,
                  decoration: InputDecoration(
                    border:const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    suffixIcon: const Icon(Icons.monetization_on,
                        color: const Color(0xFFD8AE2D)
                    ),
                    hintText: 'Enter a price',
                    labelText: 'Price',
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Active',
                    style: TextStyle(
                      fontSize: 16
                    ),),
                    Checkbox(
                      value: _active,
                      onChanged: (val){
                        setState(() {
                          _active = val;
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: const Color(0xFFAD4497),
                  onPressed: () async {
                    loaderFunction();
                    checkInternetConnection(context);
                  },
                  child: Text('CREATE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            Offer offer = new Offer(uuid.v1(), _active, _description, _name, _price);
            dynamic result = await _offersFirestoreClass.addOffer(offer);
            loaderFunction();
            Navigator.pop(context);
          }
          catch(e){
            print('error');
          }
        }
      }
    } on SocketException catch (_) {
      _formKey.currentState.validate();
      return connectionErrorToast();
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Oops! no internet connection",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Please check your connection and try again.',
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
      background: Colors.blueGrey,
      autoDismiss: false,
      slideDismiss: true,
    );
  }

  Widget connectionNotification(){
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SafeArea(
        child: ListTile(
          title: Text('Connection Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
          ),
          subtitle: Text('Please try to log in again later.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          trailing: IconButton(
              icon: Icon(Icons.close, color: Colors.white,),
              onPressed: () {
                OverlaySupportEntry.of(context).dismiss();
              }),
        ),
      ),
      color: Colors.blueGrey,);
  }

  Widget loaderFunction(){
    return ColorLoader5(
      dotOneColor: Colors.redAccent,
      dotTwoColor: Colors.blueAccent,
      dotThreeColor: Colors.green,
      dotType: DotType.circle,
      dotIcon: Icon(Icons.adjust),
      duration: Duration(seconds: 4),
    );
  }
}

