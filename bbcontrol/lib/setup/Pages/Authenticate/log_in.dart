

import 'package:bbcontrol/setup/Pages/Authenticate/sign_up.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();

  String _email, _password;
  String error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      dynamic result = await _auth.signIn(_email, _password);
                      if(result == null){
                        setState(() => error = 'Could not sign you in. Please, check your data and try again.');
                        print(error);
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
}
