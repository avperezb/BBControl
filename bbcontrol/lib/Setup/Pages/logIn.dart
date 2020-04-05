import 'package:bbcontrol/Setup/Pages/signUp.dart';
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
              onPressed: signIn,
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
                      onPressed: navigateToSignUp,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
          ],
        ),
      )
    );
  }

  Future <void> signIn() async{
    print('login');
    print(_email);
    print( _password);
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
      }catch(e) {
        print(e.message);
      }
    }
  }

  void navigateToSignUp(){
    print('holaaa navig');
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }


}