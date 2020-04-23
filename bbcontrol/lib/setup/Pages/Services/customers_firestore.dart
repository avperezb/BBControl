import 'package:bbcontrol/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class for customers CRUD operations

class CustomersFirestoreClass {

  final String id;
  final String fullName;
  final String email;
  final DateTime birthDate;
  final int phoneNumber;

  CustomersFirestoreClass({this.id, this.fullName, this.email, this.birthDate, this.phoneNumber});

  final CollectionReference _customersCollectionReference = Firestore.instance.collection('Customers');

  Future createCustomer(Customer customer) async{
    try{
      await _customersCollectionReference.document(customer.id).setData(customer.toJson());
    }catch(e){
      return e.message;
    }
  }

  Future getCustomer(String uid) async{
    try{
      var customerInfo = await _customersCollectionReference.document(uid).get();
      return Customer.fromData(customerInfo.data);
    }catch(e){
      return e.message;
    }
  }

  Future updateCustomerData(String fullName, String email, DateTime birthDate, num phoneNumber) async{
    return await _customersCollectionReference.document(id).setData({
    'id': id,
    'fullName': fullName,
    'email': email,
    'birthDate': birthDate,
    'phoneNumber': phoneNumber
    });
  }

}