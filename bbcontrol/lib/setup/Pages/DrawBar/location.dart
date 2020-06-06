import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationClass {

  Location location = new Location();

  Future<bool> isNearBBC() async{
    bool nearBBC = false;
    Firestore firestore = Firestore.instance;
    GeoFirestore geoFirestore = GeoFirestore(firestore.collection('Locations'));
    //Ubicación del usuario
    var pos = await location.getLocation();

    //Add BBC point to database
   //await geoFirestore.setLocation('BBCValeria', GeoPoint(7.901923, -72.46932));
   //await geoFirestore.setLocation('BBC93', GeoPoint(4.675762,-74.04778));

    final queryLocation = GeoPoint(pos.latitude, pos.longitude);

    // creates a new query around [currentLocation] with a radius of 6 mts
    final List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(queryLocation, 900);
    documents.forEach((document) {
      print(document.data);
    });
    print(documents.length);
    if(documents.length>0){
      nearBBC = true;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("estaEnBBCSP", nearBBC);

    return nearBBC;
  }

}