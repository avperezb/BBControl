import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'log_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage>{

  final AuthService _auth = AuthService();

  String _email, _password;
  String error = '';
  DateTime _birthDate;
  String _fullName;
  num _phoneNumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final format = DateFormat("yMd");

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
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    shadows: [
                    Shadow(
                      color: const Color(0xFF996480),
                      blurRadius: 15.0,
                      offset: Offset(5.0, 5.0),
                    ),
                    Shadow(
                      color: const Color(0xFFD8AE2D),
                      blurRadius: 15.0,
                      offset: Offset(-5.0, 5.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: TextFormField(
                    validator: (input){
                      if(input.isEmpty){
                        return 'Please type your full name';
                      }
                      if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                        return 'This field cannot contain numbers';
                      }
                    },
                    onSaved: (input) => _fullName = input,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: <Widget>[
                        DateTimeField(
                          validator: (input) {
                            if (input == null) {
                              return 'Please enter your birth date';
                            }
                            else{
                              if(!input.isBefore(new DateTime.now())){
                                return  'Not a valid date';
                              }
                            }
                          },
                          format: format,
                          decoration:const InputDecoration(
                            icon: const Icon(Icons.calendar_today,
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
                      icon: const Icon(Icons.email,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter an email address',
                      labelText: 'Email',
                    ),
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (input){
                      if(input.isEmpty){
                        return 'Please enter your phone number';
                      }
                      if(input.isNotEmpty && !isNumeric(input)){
                        return 'This field cannot contain letters';
                      }
                    },
                    onSaved: (input) => _phoneNumber = num.parse(input),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.phone,
                          color: const Color(0xFFD8AE2D)
                      ),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
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
                    icon: const Icon(Icons.remove_red_eye,
                        color: const Color(0xFFD8AE2D)
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
                  onPressed:  () async {
                    ColorLoader5(
                      dotOneColor: Colors.redAccent,
                      dotTwoColor: Colors.blueAccent,
                      dotThreeColor: Colors.green,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 2),
                    );
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      dynamic result = await _auth.signUp(
                          _email, _password, _fullName, _phoneNumber,
                          _birthDate);
                      //Se vuelve a la página de Log in
                      Navigator.of(context).pop();
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
