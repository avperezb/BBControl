import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:location/location.dart';

class LocationClass {

  bool nearBBC = false;

  Location location = new Location();

  Future<bool> isNearBBC() async{

    Firestore firestore = Firestore.instance;
    GeoFirestore geoFirestore = GeoFirestore(firestore.collection('Locations'));
    var pos = await location.getLocation();
    //await geoFirestore.setLocation('casaValeria', GeoPoint(7.901978, -72.469323));
    final locationDB = await geoFirestore.getLocation('tl0Lw0NUddQx5a8kXymO');

    final queryLocation = GeoPoint(pos.latitude, pos.longitude);
    print(queryLocation);

    // creates a new query around [currentLocation] with a radius of 6 mts
    final List<DocumentSnapshot> documents = await geoFirestore.getAtLocation(queryLocation, 6);
    documents.forEach((document) {
      print('en for each');
      print(document.data);
    });
    if(documents.length!=0){
      nearBBC = true;
    }
    print(nearBBC);
    return nearBBC;
  }


}