import 'package:bbcontrol/models/finalOrderProduct.dart';
import 'package:bbcontrol/models/orderProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersFirestoreClass {

  final String id;
  bool done = false;
  OrdersFirestoreClass({this.id});

  final CollectionReference _ordersCollectionReference = Firestore.instance
      .collection('Orders');

  Future addOrder(OrderProduct orderProduct) async {
    String message = '';
    try {
      await _ordersCollectionReference.document().setData(
          orderProduct.toJson());
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

  Future updateOrder(String fullName, String email, String,
      DateTime birthDate, num phoneNumber) async {
    return await _ordersCollectionReference.document(id).setData({
      'id': id,
      'fullName': fullName,
      'email': email,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber
    });
  }
}