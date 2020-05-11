import 'package:bbcontrol/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class for customers CRUD operations

class CustomersFirestoreClass {

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String birthDate;
  final int phoneNumber;
  final num limitAmount;

  CustomersFirestoreClass({this.id, this.firstName, this.lastName, this.email, this.birthDate, this.phoneNumber, this.limitAmount});

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

  Future updateCustomerData(String id, String firstName, String lastName, String email, DateTime birthDate, num phoneNumber) async{
    try {
      await _customersCollectionReference.document(id).updateData({
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber
      });
    }catch(e){
      return e.message;
    }
  }

  Future setLimitAmount(String idUser, num amount) async {
    try {
      await _customersCollectionReference.document(idUser).updateData({
        'limitAmount': amount,
      });
    }catch(e){
      return e.message;
    }
  }

}