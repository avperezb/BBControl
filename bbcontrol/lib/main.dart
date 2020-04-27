import 'package:bbcontrol/setup/Pages/DrawBar/edit_Profile.dart';
import 'package:bbcontrol/setup/Pages/Drinks/drinks.dart';
import 'package:bbcontrol/setup/Pages/Food/food.dart';
import 'package:bbcontrol/setup/Pages/Home/home.dart';
import 'package:bbcontrol/setup/Pages/Offers/offers.dart';
import 'package:bbcontrol/setup/Pages/Order/order.dart';
import 'package:bbcontrol/setup/Pages/Transport/transportation.dart';
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
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/Food':
        return MaterialPageRoute(
          builder: (_) => FoodList(
            userId: args,
          ),
        );
      case '/ViewProfile' :
        return MaterialPageRoute(
          builder: (_) => ProfilePage(),
        );
      case '/Drinks' :
        return MaterialPageRoute(
          builder: (_) => DrinksTabs(
            userId: args,
          ),
        );
      case '/Order' :
        return MaterialPageRoute(
          builder: (_) => OrderPage(
            userId: args,
          ),
        );
      case '/Cab' :
        return MaterialPageRoute(
          builder: (_) => Transport()
        );
      case '/Offers' :
        return MaterialPageRoute(
            builder: (_) => Offers()
        );
    }
  }
}