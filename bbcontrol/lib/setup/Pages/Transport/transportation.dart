import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';

class Transport extends StatefulWidget {
  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  List<Map<String, String>> installedApps;
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

      _installedApps = await AppAvailability.getInstalledApps();

      print(await AppAvailability.checkAvailability("com.cabify.rider"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await AppAvailability.isAppEnabled("com.cabify.rider"));
      // Returns: true


    setState(() {
      installedApps = _installedApps;
    });

  }
  @override
  Widget build(BuildContext context) {
    if (installedApps == null)
      getApps();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Request cab'),
          centerTitle: true,
          backgroundColor: const Color(0xFFD7384A),
        ),
        body: ListView.builder(
          itemCount: installedApps == null ? 0 : installedApps.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(installedApps[index]["app_name"]),
              trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                    AppAvailability.launchApp(installedApps[index]["package_name"]).then((_) {
                      print("App ${installedApps[index]["app_name"]} launched!");
                    }).catchError((err) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("App ${installedApps[index]["app_name"]} not found!")
                      ));
                      print(err);
                    });
                  }
              ),
            );
          },
        ),
      ),
    );
  }
}
