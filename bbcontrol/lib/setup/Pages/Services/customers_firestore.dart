import 'package:bbcontrol/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class for customers CRUD operations

class CustomersFirestoreClass {


  final String id;

  CustomersFirestoreClass({this.id});

  final CollectionReference _customersCollectionReference = Firestore.instance.collection('Customers');

  Future createCustomer(Customer customer) async{
    try{
      await _customersCollectionReference.document(customer.id).setData(customer.toJson());
    }catch(e){
      return e.message;
    }
  }

  Future updateCustomerData(String fullName, String email, String, DateTime birthDate, num phoneNumber) async{
    return await _customersCollectionReference.document(id).setData({
    'id': id,
    'fullName': fullName,
    'email': email,
    'birthDate': birthDate,
    'phoneNumber': phoneNumber
    });
  }

}