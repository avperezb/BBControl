import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckConnectivityState {

  bool cStatus = true;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  //StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void initState() {
    initConnectivity();
    //_connectivitySubscription =
    //_connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

/*  void dispose() {
    _connectivitySubscription.cancel();
  }*/

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      print(result);
      await updateConnectionStatus(result);
    } catch (e) {
      print(e.toString());
    }

    return updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    initState();
  }

  bool getConnectionStatus(BuildContext context){
    build(context);
    return cStatus;
  }

  void setConnectionStatus(bool status){
    cStatus = status;
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiBSSID, wifiIP;
        cStatus = true;
        try {
          wifiName = await _connectivity.getWifiName();
        } catch (e) {
          print(e.toString());
        }

        try {
          wifiBSSID = await _connectivity.getWifiBSSID();
        } catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        _connectionStatus = await '$result\n'
            'Wifi Name: $wifiName\n'
            'Wifi BSSID: $wifiBSSID\n'
            'Wifi IP: $wifiIP\n';

        break;
      case ConnectivityResult.mobile:
        _connectionStatus = result.toString();
        cStatus = true;
        break;
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        cStatus = false;
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        cStatus = true;
        break;
    }
    setConnectionStatus(cStatus);
  }
}
