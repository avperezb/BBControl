import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:store_redirect/store_redirect.dart';

class Transport extends StatefulWidget {
  @override
  _TransportState createState() => new _TransportState();
}

class _TransportState extends State<Transport> {

  List<Map<String, String>> installedApps;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();

      // print(await AppAvailability.checkAvailability("com.cabify.rider"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      //print(await AppAvailability.isAppEnabled("com.cabify.rider"));
      // Returns: true

    }

    setState(() {
      installedApps = _installedApps;
    });

  }

  @override
  Widget build(BuildContext context) {
    if (installedApps == null)
      getApps();

    return Scaffold(
        appBar: AppBar(
          title: Text('Request cab'),
          centerTitle: true,
          backgroundColor: const Color(0xFFB75ba4),
        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB75ba4), Colors.white])
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              showContent(),
              Container(
                margin: EdgeInsets.all(40),
                child: Text('We want you to get home safe, catch a ride from Cabify!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400
                  ),),
              ),
            ],
          ),
        )
    );
  }

  getCabifyApp(){
    if(installedApps != null){
      for(Map<String, String> current in installedApps){
        if(current['app_name'] == 'Cabify') return current;
      }
    }
    else return null;
  }

  showContent(){
    if (getCabifyApp() != null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: ExactAssetImage('assets/images/cabify.png')
                      )
                  ),
                ),
                Text('Open Cabify',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF7350FF),
                      fontWeight: FontWeight.w700
                  ),),
              ],
            ),
            onTap: () async{
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  AppAvailability.launchApp(getCabifyApp()['package_name']);
                }
              } on SocketException catch (_) {
                return connectionErrorToast();
              }
            },
          ),
        ],
      );
    }
    else{
      return Column(
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: ExactAssetImage('assets/images/cabify.png')
                      )
                  ),
                ),
                Text('It looks like you don\'t have Cabify \nGet it now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF7350FF),
                      fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            onTap: () async{
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  StoreRedirect.redirect(
                      androidAppId: 'com.cabify.rider'
                  );
                }
              } on SocketException catch (_) {
                return connectionErrorToast();
              }
            },
          )
        ],
      );
    }
  }

  connectionErrorToast(){
    return showSimpleNotification(
      Text("Oops! no internet connection",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),),
      subtitle: Text('Please check your connection and try again.',
        style: TextStyle(
        ),),
      trailing: Builder(builder: (context) {
        return FlatButton(
            textColor: Colors.white,
            onPressed: () {
              OverlaySupportEntry.of(context).dismiss();
            },
            child: Text('Dismiss',
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16
              ),));
      }),
      background: Colors.blueGrey,
      autoDismiss: false,
      slideDismiss: true,
    );
  }
}