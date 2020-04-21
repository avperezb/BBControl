import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _email, error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool isConnected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text('Login Help',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Color(0xFFD7384A),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
              child: Text('Reset Your Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
              ),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
              child: Text('Enter the email linked to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17, color: Colors.black),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type an email';
                    }
                    if(input.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                      return 'Please type a valid email';
                    }
                  },
                  onChanged: (input) {
                    setState(() => _email = input);
                  },
                  decoration: InputDecoration(
                    border:const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    prefixIcon: const Icon(Icons.email,
                        color: const Color(0xFFD7384A)
                    ),
                    hintText: 'Enter an email address',
                    labelText: 'Email',
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  color: const Color(0xFFD7384A),
                  onPressed: () async {
                    checkConnectivity(context);
                    if(!isConnected){
                      showOverlayNotification((context) {
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
                      }, duration: Duration(milliseconds: 4000));;
                    }
                    ColorLoader5(
                      dotOneColor: Colors.redAccent,
                      dotTwoColor: Colors.blueAccent,
                      dotThreeColor: Colors.green,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 1),
                    );
                    if(_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      dynamic result = await _auth.resetPassword(_email);
                      if (result == null) {
                        setState(() =>
                        error =
                        'Could not sign you in. Please, check your data and try again.');
                        return Container(
                          margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                          child: Text(error,
                            style: TextStyle(
                              color: const Color(0xFFD7384A),
                            ),),
                          color: Colors.black12,
                        );
                      }
                      else {
                        showOverlayNotification((context) {
                          return Card(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: SafeArea(
                              child: ListTile(
                                title: Text('Password recovery',
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                ),
                                subtitle: Text(
                                  'A password reset link has been sent to $_email.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.close, color: Colors.white,),
                                    onPressed: () {
                                      OverlaySupportEntry.of(context).dismiss();
                                    }),
                              ),
                            ),
                            color: Colors.cyan);
                        }, duration: Duration(milliseconds: 4000));
                        ;
                      }
                    }
                  },
                  child: Text('Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                )
            ),
          ],
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
}
