import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {

  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: TextFormField(
                validator: (input){
                  if(input.isEmpty){
                    return 'Please type an email';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
              ),
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
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Text('Sign in',
                style: TextStyle(
                  color: Colors.white,
                ),),
              ),
            )
          ],
        ),
      )
    );
  }

  Future <void> signIn() async{

    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
      }catch(e) {
        print(e.message);
      }
    }
  }

}