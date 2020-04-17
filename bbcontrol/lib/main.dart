
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
        ),
      ),
    );
  }
}
