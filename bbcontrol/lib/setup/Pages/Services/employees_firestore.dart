import 'package:bbcontrol/models/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Class for customers CRUD operations

class EmployeesFirestoreClass {

  final String id;
  final bool active;
  final num identification;
  final String firstName;
  final String lastName;
  final String email;
  final int phoneNumber;

  EmployeesFirestoreClass({this.id, this.active, this.identification, this.firstName, this.lastName, this.email, this.phoneNumber});

  final CollectionReference _employeesCollectionReference = Firestore.instance.collection('BBCEmployees');

  Future createEmployee(Employee employee) async{
    try{
      await _employeesCollectionReference.document(employee.id).setData(employee.toJson());
    }catch(e){
      return e.message;
    }
  }

  Future getCustomer(String id) async{
    try{
      var employeeInfo = await _employeesCollectionReference.document(id).get();
      return Employee.fromData(employeeInfo.data);
    }catch(e){
      return e.message;
    }
  }

  Future updateEmployeeData(String id, bool active, String firstName, String lastName, String email, num phoneNumber) async{

    try {
      await _employeesCollectionReference.document(id).setData({
        'id': id,
        'active': active,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber
      });
    }catch(e){
      return e.message;
    }
  }

}