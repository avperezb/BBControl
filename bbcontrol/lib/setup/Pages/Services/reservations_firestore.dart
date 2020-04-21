import 'package:bbcontrol/models/finalOrderProduct.dart';
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
      await _reservationsCollectionReference.document().setData(
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

  bool getOperationStatus(){
    return done;
  }

  /*Future updateReservation(String fullName, String email, String,
      DateTime birthDate, num phoneNumber) async {
    return await _ordersCollectionReference.document(id).setData({
      'id': id,
      'fullName': fullName,
      'email': email,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber
    });
  }*/
}