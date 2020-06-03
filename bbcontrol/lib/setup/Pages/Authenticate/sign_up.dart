import 'dart:io';

import 'package:age/age.dart';
import 'package:bbcontrol/setup/Pages/Authenticate/log_in.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage>{

  String _email, _password;
  String error = '';
  DateTime _birthDate;
  String _firstName;
  String _lastName;
  num _phoneNumber;
  final AuthService _auth = AuthService();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool isConnected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final format = DateFormat("yMd");

  Widget build(BuildContext context) {
    isConnected = checkConnection.getConnectionStatus(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Registration',
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
                        feedback = 'Please type your first name';
                      }
                      if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                        feedback = 'This field cannot contain numbers or special characters';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    onSaved: (input) => _firstName = input,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.person,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter your first name',
                      labelText: 'First name',
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
                        feedback = 'Please type your last name';
                      }
                      if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                        feedback =  'This field cannot contain numbers or special characters';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    onSaved: (input) => _lastName = input,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.person_outline,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter your last name',
                      labelText: 'Last name',
                    ),
                    maxLength: 20,
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                      children: <Widget>[
                        DateTimeField(
                            validator: (input) {
                              String feedback;
                              if (input == null) {
                                feedback = 'Please enter your birth date';
                              }
                              else if(input.isBefore(new DateTime.now())){
                                var age = Age.dateDifference(
                                    fromDate: input, toDate: new DateTime.now(), includeToDate: false);
                                if(age.years < 18) {
                                  feedback = 'You must be 18 years old or above';
                                }
                              }
                              else feedback = null;
                              return feedback;
                            },
                            format: format,
                            decoration:const InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_today,
                                    color: const Color(0xFFD8AE2D)
                                ),
                                labelText: 'Date of birth'
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                            onSaved: (input) => _birthDate = input
                        ),
                      ])
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (input){
                      String feedback;
                      if(input.isEmpty){
                        feedback = 'Please type an email';
                      }
                      else if(!input.isEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                        feedback = 'Please type a valid email';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.alternate_email,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter an email address',
                      labelText: 'Email',
                    ),
                    maxLength: 30,
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (input){
                      String feedback;
                      if(input.isNotEmpty){
                        String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (!regExp.hasMatch(input)) {
                          feedback =  'Please enter valid mobile number';
                        }
                      }
                      else if(input.isEmpty){
                        feedback = 'Please enter your phone number';
                      }
                      else feedback = null;
                      return feedback;
                    },
                    maxLength: 10,
                    onSaved: (input) => _phoneNumber = num.parse(input),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.phone,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextFormField(
                  validator: (input) {
                    String feedback;
                    if(input.isNotEmpty){
                      String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
                      RegExp regExp = new RegExp(pattern);
                      if (!regExp.hasMatch(input)) {
                        feedback = 'No special characters, at least 1 letter and 1 number.';
                      }
                      if(input.length<6){
                        feedback = 'Your password needs to be at least 6 characters';
                      }
                    }
                    else if(input.isEmpty){
                      feedback = 'Please enter your password';
                    }
                    return feedback;
                  },
                  onChanged: (input) {
                    setState(() => _password = input);
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.remove_red_eye,
                        color:const Color(0xFFD8AE2D)
                    ),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                  obscureText: true,
                  maxLength: 15,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  color: const Color(0xFFAD4497),
                  onPressed: () async {
                    loaderFunction();
                    checkInternetConnection(context);
                  },
                  child: Text('Register',
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
  void checkConnectivity(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      isConnected = checkConnection.getConnectionStatus(context);
    });
  }

  checkInternetConnection(context) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            dynamic result = await _auth.signUp(
                _email,
                _password,
                _firstName,
                _lastName,
                _phoneNumber,
                _birthDate,
                num.parse('0'));
          }
          catch(e){
            return existingUserErrorToast("This email is already in use");
          }
          print(_email + _password);

          loaderFunction();
          Navigator.push(context, MaterialPageRoute(builder: (
              context) => LoginPage()));
          userAddedToast();
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

  existingUserErrorToast(String error){
    return showSimpleNotification(
      Text(error,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
      ),
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

  userAddedToast(){
    return showSimpleNotification(
      Text("Registration successful",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
      ),
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

