import 'package:connectivity/connectivity.dart';
import 'package:overlay_support/overlay_support.dart';

class CheckConnectivity {

  Future<String> checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return await 'No internet connection';
    } else if (result == ConnectivityResult.mobile) {
      return await 'Connection on mobile data';
    } else if (result == ConnectivityResult.wifi) {
      return await 'Connection by wifi';
    }
  }

}
