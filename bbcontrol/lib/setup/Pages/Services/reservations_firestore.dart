import 'package:bbcontrol/models/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsFirestoreClass {

  final String id;
  bool done = false;
  ReservationsFirestoreClass({this.id});

  final CollectionReference _reservationsCollectionReference = Firestore.instance
      .collection('Reservations');

  Future addReservation(Reservation reservation) async {
    String message = '';
    try {
      print(reservation.toJson());
      await _reservationsCollectionReference.document(reservation.id).setData(
          reservation.toJson());
    } catch (e) {
      message = e.message;
    }
    if(message.length==0){
      done = true;
    }
    else{
      done = false;
    }
  }

  Future updateReservation(Reservation reservation) async{
    try {
      await _reservationsCollectionReference.document(reservation.id).setData({
        'date' : reservation.date,
        'start' : reservation.startTime,
        'end' : reservation.endTime,
        'num_people' : reservation.numPeople,
        'preferences' : reservation.preferences,
        'id' : reservation.id,
        'user_Id' : reservation.userId
      });
    }catch(e){
      return e.message;
    }
  }

  bool getOperationStatus(){
    return done;
  }

}