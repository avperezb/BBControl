
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'log_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage>{

  final AuthService _auth = AuthService();

  String _email, _password;
  String error = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Registration',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Color(0xFFFF6B00),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
            children: <Widget>[
              Text('Enter your information',
                style: TextStyle(
                    fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return 'Please type an email';
                      }
                      if(!input.isEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                        return 'Please type a valid email';
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        labelText: 'Email'
                    ),
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: TextFormField(
                  validator: (input){
                    if(input.length<6){
                      return 'Your password needs to be atleast 6 characters';
                    }
                  },
                  onSaved: (input)=> _password = input,
                  decoration: InputDecoration(
                      labelText: 'Password'
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
                  onPressed:  () async {
                    if(_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      dynamic result = await _auth.signUp(_email, _password);
                      //Se vuelve a la página de Log in
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
                  child: Text('Register',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),),
                ),
              ),
            ]
        ),
      ),
    );
  }
}