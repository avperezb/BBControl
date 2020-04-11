
import 'package:bbcontrol/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'Authenticate/authenticate.dart';
import 'home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else{
      print('user logged in');
      return Home();
    }

  }
}
