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
    return Scaffold(
      appBar: AppBar(
        title: Text('BBControl'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              validator: (input){
                var msg;
                if(input.isEmpty){
                  msg = 'Please type an email';
                }
                return msg;
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextFormField(
              validator: (input){
                var msg;
                if(input.length<6){
                  msg = 'Your password needs to be atleast 6 characters';
                }
                return msg;
              },
              onSaved: (input)=> _password = input,
              decoration: InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signIn,
              child: Text('Sign in'),
            ),
            Container(
                child: Row(
                  children: <Widget>[
                    Text('Not registered yet?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
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

  void signIn() async{

    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(user: user)));
      }catch(e) {
        print(e.message);
      }
    }
  }

  void navigateToSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
  }


}