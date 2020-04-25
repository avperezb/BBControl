import 'package:bbcontrol/models/orderProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersFirestoreClass {

  final String id;
  num status = 0;

  OrdersFirestoreClass({this.id, this.status});

  final CollectionReference _ordersCollectionReference = Firestore.instance
      .collection('Orders');

  Future addOrder(OrderProduct orderProduct) async {
    try {
      await _ordersCollectionReference.document().setData(
          orderProduct.toJson());
    } catch (e) {
      e.message;
    }
  }

  num getOperationStatus() {
    return status;
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

  Future setInitialStatus() async{
    return await _ordersCollectionReference.document(id).setData({
      'status': status
    });
  }
}