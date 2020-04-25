
import 'package:bbcontrol/models/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'Authenticate/authenticate.dart';
import 'Home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Employee>(context);
    //return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else{

      return Home(customer: user);
    }

  }
}
