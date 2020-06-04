
import 'package:bbcontrol/models/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'Authenticate/authenticate.dart';
import 'Home/home.dart';
import 'DrawBar/drunk_Mode.dart';

class Wrapper extends StatelessWidget {
  LocationClass lc = LocationClass();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Customer>(context);
    //return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else{
      bool inBBC = false;
      lc.isNearBBC().then((value){
        inBBC = value;
      });
      print('eeeeeeeeeeeeeeeeeeeeeeeeepa');
      print(inBBC);
      return Home(customer: user, inBBC: inBBC);
    }

  }
}
