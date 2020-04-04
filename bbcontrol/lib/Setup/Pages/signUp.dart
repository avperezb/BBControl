import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logIn.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignupPage>{
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Registration'),
      ),
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
                      var msg = '';
                      if(input.isEmpty){
                        msg = 'Please type an email';
                      }
                      return msg;
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
                    var msg = '';
                    if(input.length<6) {
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
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  color: const Color(0xFFD7384A),
                  onPressed: signUp,
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
  void signUp() async{

    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        user.sendEmailVerification();
        print('creating user');
        //Display for the user that we sent an email.
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(e) {
        print(e.message);
      }
    }
  }
}