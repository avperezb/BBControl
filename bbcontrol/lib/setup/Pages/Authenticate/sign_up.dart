import 'package:age/age.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Home/home.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:passwordfield/passwordfield.dart';

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
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextFormField(
                  validator: (input){
                    if(input.isEmpty){
                      return 'Please type your first name';
                    }
                    if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                      return 'This field cannot contain numbers or special characters';
                    }
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
                    if(input.isEmpty){
                      return 'Please type your last name';
                    }
                    if(input.isNotEmpty && !RegExp(r'^[a-z A-Z,.\-]+$').hasMatch(input)){
                      return 'This field cannot contain numbers or special characters';
                    }
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
                            if (input == null) {
                              return 'Please enter your birth date';
                            }
                            else{
                              if(input.isBefore(new DateTime.now())){
                                var age = Age.dateDifference(
                                    fromDate: input, toDate: new DateTime.now(), includeToDate: false);
                                if(age.years < 18) {
                                  return 'You must be 18 years old or above';
                                }
                              }
                              else {
                                return  'Not a valid date';
                              }
                            }
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
                    if(input.isEmpty){
                      return 'Please type an email';
                    }
                    if(!input.isEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                      return 'Please type a valid email';
                    }
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
                    if(input.isNotEmpty){
                      String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
                      RegExp regExp = new RegExp(patttern);
                      if (!regExp.hasMatch(input)) {
                        return 'Please enter valid mobile number';
                      }
                    }
                    else{
                      return 'Please enter your phone number';
                    }
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
                  if(input.isNotEmpty){
                    String patttern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
                    RegExp regExp = new RegExp(patttern);
                    if (!regExp.hasMatch(input)) {
                      return 'Non special characters, at least 1 letter and number 6+ chars.';
                    }
                    if(input.length<6){
                      return 'Your password needs to be atleast 6 characters';
                    }
                  }
                  else{
                    return 'Please enter your password';
                  }
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
                  checkConnectivity(context);
                  if(!isConnected){
                    showOverlayNotification((context) {
                      return connectionNotification();
                    }, duration: Duration(milliseconds: 4000));
                  }
                  else{
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      dynamic result = await _auth.signUp(
                          _email, _password, _firstName, _lastName, _phoneNumber,
                          _birthDate, num.parse('0'));
                        print(_email + _password);
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => Home(customer: result)));
                    }
                  }
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
    );
  }
  void checkConnectivity(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      isConnected = checkConnection.getConnectionStatus(context);
    });
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
      duration: Duration(seconds: 2),
    );
  }
}

