import 'package:bbcontrol/setup/Pages/Drinks/drinks.dart';
import 'package:bbcontrol/setup/Pages/Food/food.dart';
import 'package:bbcontrol/setup/Pages/Home/home.dart';
import 'package:bbcontrol/setup/Pages/Order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'models/customer.dart';
import 'setup/Pages/Services/auth.dart';
import 'setup/Pages/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: StreamProvider<Customer>.value(
        value: AuthService().user ,
        child: MaterialApp(
            home: Wrapper(),
            routes : <String, WidgetBuilder>{
              '/Food' : (BuildContext context)=> FoodList(),
              '/Drinks' : (BuildContext context)=> DrinksTabs(),
              '/Order' : (BuildContext context)=>OrderPage(),
            }
        ),
      ),
    );
  }
}
