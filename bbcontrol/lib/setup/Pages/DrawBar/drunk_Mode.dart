import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math';

class FireMap extends StatefulWidget{
  State createState()=>FireMapState();
}
class FireMapState extends State<FireMap>{
  GoogleMapController mapController;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    //BehaviorSubject<double> radius = BehaviorSubject();
    getCurrentLocation();
    // TODO: implement build
    return  Stack(
      children: <Widget>[
        GoogleMap(initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom: 15
        ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        )
      ],
    );
  }

  Widget randomOperation(){
    int max = 5;
    int min = 3;
    Random rnd = new Random();
    int r = min + rnd.nextInt(max - min+1);
    return Container(
      child: Row(
        children: <Widget>[
          Card(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
            ),
          ),
        ],
      ),
    );
  }

  _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;
    });
  }



  Future<DocumentReference> getCurrentLocation() async{

    var pos = await location.getLocation();
    print(pos);
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    print('aaaaaaaaaaaaaaaaaaaaaaaa');
    print(point);
  }


}