import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:location/location.dart';

class LocationClass {

  bool nearBBC = false;

  Location location = new Location();

  Future<bool> isNearBBC() async{

    Firestore firestore = Firestore.instance;
    GeoFirestore geoFirestore = GeoFirestore(firestore.collection('Locations'));
    //Ubicación del usuario
    var pos = await location.getLocation();
    print('ubicación usuario:');
    print(pos);

    //Add BBC point to database
    await geoFirestore.setLocation('BBCValeria', GeoPoint(7.901923, -72.46932));

    final queryLocation = GeoPoint(pos.latitude, pos.longitude);

    // creates a new query around [currentLocation] with a radius of 6 mts
    final List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(queryLocation, 6);
    documents.forEach((document) {
      print(document.data);
    });
    print(documents.length);
    if(documents.length!=0){
      nearBBC = true;
    }
    return nearBBC;
  }

}