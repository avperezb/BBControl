import 'package:age/age.dart';
import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:bbcontrol/setup/Pages/Services/auth.dart';
import 'package:bbcontrol/setup/Pages/Services/connectivity.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ProfilePage extends StatefulWidget{

  final String userId;
  const ProfilePage({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage>{

  String _firstName, _lastName, _email;
  num _phoneNumber;
  DateTime _birthDate;
  bool readOnly = true;
  String pageTitle = 'Your profile';
  String buttonText = 'Edit';
  final format = DateFormat("yMd");CheckConnectivityState checkConnection = CheckConnectivityState();
  bool isConnected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CustomersFirestoreClass customersDB = CustomersFirestoreClass();
  String vista = '1';

  void changeViewEditable(){
    setState(() {
      print('cambiando estado');
      readOnly = false;
      pageTitle = 'Edit profile';
      buttonText = 'Save';
    });
    print('a editar');
    if(vista == '2'){
      setState(() {
        print('cambiando estado 2');
        readOnly = true;
        pageTitle = 'Your profile';
        buttonText = 'Edit';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('estado inicial');
    print(readOnly);
    return StreamBuilder(
      stream: Firestore.instance.collection('Customers').document('${widget.userId}').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(pageTitle),
              backgroundColor: const Color(0xFFAD4497),
            ),
            body: Center(
              child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFffcc94),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Text('Oops!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Text('It looks like there was a problem! Come back later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          );
        }
        else {
          return StatefulBuilder(
            builder: (context, StateSetter setState) =>
                Scaffold(
                  appBar: AppBar(
                    title: Text('$pageTitle'),
                    backgroundColor: const Color(0xFFAD4497),
                  ),
                  bottomSheet: Card(
                    elevation: 6.0,
                    child: Container(height: MediaQuery.of(context).size.height * 0.1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          color: const Color(0xFFAD4497),
                          onPressed: () async {loaderFunction();
                          checkConnectivity(context);
                          if(!isConnected){
                            showOverlayNotification((context) {
                              return connectionNotification();
                            }, duration: Duration(milliseconds: 4000));
                          }
                          else{
                            if (_formKey.currentState.validate()) {
                              print('hola, editaré el perfilll jeje');
                              _formKey.currentState.save();
                              print('on pressed');
                              changeViewEditable();
                              await customersDB.updateCustomerData(widget.userId, _firstName, _lastName, _email, _birthDate, _phoneNumber);
                              if (vista == '2'){
                                Navigator.pushNamedAndRemoveUntil(context, '/ViewProfile', ModalRoute.withName('/'));
                              }
                              else{
                                print('periko');
                              }
                            }
                          }
                          },
                          child: Text('$buttonText',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  body:
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child:
                      ListView(
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('First name: ',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                Flexible(
                                    child: TextFormField(
                                      readOnly: readOnly,
                                      initialValue: snapshot.data['firstName'],
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
                                        border:const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                        ),
                                        hintText: 'Enter your first name',
                                        contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                      ),
                                      maxLength: 20,
                                    )
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('Last name: ',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextFormField(
                                    initialValue: snapshot.data['lastName'],
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
                                      border:const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                      ),
                                      hintText: 'Enter your last name',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                    ),
                                    maxLength: 20,
                                    readOnly: readOnly,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('Email: ',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextFormField(
                                    readOnly: readOnly,
                                    initialValue: snapshot.data['email'],
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please type an email';
                                      }
                                      if(input.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)){
                                        return 'Please type a valid email';
                                      }
                                    },
                                    onSaved: (input) {
                                      setState(() => _email = input);
                                    },
                                    decoration: InputDecoration(
                                      border:const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                      ),
                                      hintText: 'Enter your email',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                    ),
                                    maxLength: 30,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('Birthday: ',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: DateTimeField(
                                    readOnly: readOnly,
                                    format: format,
                                    initialValue: snapshot.data['birthDate'].toDate(),
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
                                    decoration: InputDecoration(
                                      border:const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                      ),
                                      hintText: 'Enter your birth date',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate: currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                    },
                                    onSaved: (input) => _birthDate = input,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 22, 0, 20),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Text('Phone number: ',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    initialValue: snapshot.data['phoneNumber'].toString(),
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
                                      border:const OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                                      ),
                                      hintText: 'Enter your phone number',
                                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                    ),
                                    readOnly: readOnly,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          );
        }
      },
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