import 'package:bbcontrol/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class for customers CRUD operations

class CustomersFirestoreClass {

  final CollectionReference _customersCollectionReference = Firestore.instance.collection('Customers');

  Future createCustomer(Customer customer) async{
    try{
      await _customersCollectionReference.document(customer.id).setData(customer.toJson());
    }catch(e){
      return e.message;
    }
  }

}