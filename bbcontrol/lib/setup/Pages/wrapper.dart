
import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/models/employees.dart';
import 'package:bbcontrol/setup/Pages/Waiter/OrdersList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Authenticate/authenticate.dart';
import 'Extra/ColorLoader.dart';
import 'Extra/DotType.dart';
import 'Home/home.dart';
import 'DrawBar/location.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  LocationClass lc = LocationClass();
  bool inBBC;
  String _email;
  String _id;
  String _firstName;
  String _lastName;
  DateTime _birthDate;
  int _phoneNumber;
  num _limitAmount;
  num _ordersAmount;
  num _identification;
  bool _active;

  @override
  void initState() {
    getEmailFromSP();
    isNearBBC();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate widget
    if(_email == null){
      return Authenticate();
    }
    else if(_email.contains('@bbc.com')){
      loaderFunction();
      getEmployeeDataFromSP();
      Employee employee = new Employee(
          id: _id,
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          ordersAmount: _ordersAmount,
          identification: _identification,
          active: _active,
          phoneNumber: _phoneNumber);
      return OrdersListWaiter(employee: employee);
    }
    else if(_email.contains('@adminbbc.com')){

    }
    else{
      loaderFunction();
      getUserDataFromSP();
      Customer customer = new Customer(
          phoneNumber: _phoneNumber,
          limitAmount: _limitAmount,
          lastName: _lastName,
          id: _id,
          firstName: _firstName,
          email: _email,
          birthDate: _birthDate);
      return Home(customer: customer, inBBC: inBBC);
    }
  }

  isNearBBC() async{
    bool rta = await lc.isNearBBC();
    setState(() {
      inBBC = rta;
    });
  }

  getEmailFromSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
  }

  getEmployeeDataFromSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id');
      _firstName = prefs.getString('first_name');
      _lastName = prefs.getString('last_name');
      _ordersAmount = prefs.getInt('orders_amount');
      _identification = prefs.getInt('identification');
      _active = prefs.getBool('active');
      _phoneNumber = prefs.getInt('phone_number');
    });
  }

  getUserDataFromSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id');
      _firstName = prefs.getString('first_name');
      _lastName = prefs.getString('last_name');
      _birthDate = DateTime.parse(prefs.getString('birth_date'));
      _phoneNumber = prefs.getInt('phone_number');
      _limitAmount = prefs.getInt('limit_amount');
    });
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

