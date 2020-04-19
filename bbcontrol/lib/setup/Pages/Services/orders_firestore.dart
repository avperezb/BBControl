import 'package:bbcontrol/models/orderProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersFirestoreClass {

  final String id;

  OrdersFirestoreClass({this.id});

  final CollectionReference _ordersCollectionReference = Firestore.instance
      .collection('Orders');

  Future addProductToOrder(OrderProduct orderProduct) async {
    try {
      await _ordersCollectionReference.document(orderProduct.id).setData(
          orderProduct.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future createOrder(List<OrderProduct> listOfOrders) async{

    for (int i = 0; i< listOfOrders.length; i++){
        await addProductToOrder(listOfOrders[i]);
    }

  }

  Future updateProductOfOrder(String fullName, String email, String,
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