

import 'package:bbcontrol/setup/Pages/Authenticate/sign_up.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginPage extends StatefulWidget {

  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();

  String _email, _password;
  String error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;

  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Image.asset('assets/images/logo.png',
                  height: 220,
                  width: 220,
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
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
                      icon: const Icon(Icons.email,
                          color: const Color(0xFFD7384A)
                      ),
                      hintText: 'Enter an email address',
                      labelText: 'Email',
                    ),
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                child: TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Your password needs to be atleast 6 characters';
                    }
                  },
                  onChanged: (input) {
                    setState(() => _password = input);
                  },
                  decoration: InputDecoration(
                    icon: const Icon(Icons.remove_red_eye,
                        color: const Color(0xFFD7384A)
                    ),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  color: const Color(0xFFD7384A),
                  onPressed: () async {
                    showToast(context);
                    if(!cStatus){
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
                    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      dynamic result = await _auth.signIn(_email, _password);
                      if(result == null){
                        setState(() => error = 'Could not sign you in. Please, check your data and try again.');
                        return Container(
                          margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                          child: Text(error,
                            style: TextStyle(
                              color: const Color(0xFFD7384A),
                            ),),
                          color: Colors.black12,
                        );
                      }
                    }
                  },
                  child: Text('Log in',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text('Not registered yet?',
                          style: TextStyle(fontSize: 16)
                      ),
                      FlatButton(
                          textColor: const Color(0xFFD7384A),
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                            ColorLoader5(
                              dotOneColor: Colors.redAccent,
                              dotTwoColor: Colors.blueAccent,
                              dotThreeColor: Colors.green,
                              dotType: DotType.circle,
                              dotIcon: Icon(Icons.adjust),
                              duration: Duration(seconds: 1),
                            );
                          }
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
            ],
          ),
        )
    );
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
    });
  }

}
