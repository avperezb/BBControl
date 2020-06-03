import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/models/employees.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:bbcontrol/setup/Pages/Services/employees_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomersFirestoreClass _firestoreService = CustomersFirestoreClass();
  final EmployeesFirestoreClass _firestoreEmployees = EmployeesFirestoreClass();
  Customer _currentCustomer;

  Future<String> getCurrentUserId() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userId = user.uid;
    return userId;
  }


  //Create object based on FirebaseUser
  Customer _userFromFirebaseUser(FirebaseUser user){
    return user != null ? Customer(id: user.uid, firstName: user.displayName) : null;
  }

  Employee _employeeFromFirebaseUser(FirebaseUser user){
    return user != null ? Employee(id: user.uid, firstName: user.displayName) : null;
  }

  //Auth change user stream
  Stream<Customer> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future<FirebaseUser> get currentIdUser async{
    var r = await _auth.currentUser();
    return r;
  }
  String getId(){
    return getCurrentUserId().toString();
  }

  //Sign in email-password

  Future signIn(String _email, String _password) async {
    print('log in');
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
          email: _email, password: _password)).user;
      if (_email.contains('@bbc.com')) {
        print(_employeeFromFirebaseUser(user).toString() +
            'imprimiendo usuario creado');
        return await _firestoreEmployees.getEmployee(user.uid);
      }
      else {
        print(_userFromFirebaseUser(user).toString() +
            'imprimiendo usuario creado');
        Customer customer = await _firestoreService.getCustomer(user.uid);
        print(customer);
        return customer;
      }
    } catch (e) {
      return "error";
    }
  }

  //Register email-password
  Future signUp(String _email, String _password, String _firstName,
      String _lastName, num _phoneNumber, DateTime _birthDate,
      num _limitAmount) async {
    print('intento crear');
    try {
      print('holaaa');
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password)).user;
      user.sendEmailVerification();

      return await _firestoreService.createCustomer(Customer(
          id: user.uid,
          email: _email,
          firstName: _firstName,
          lastName: _lastName,
          birthDate: _birthDate,
          phoneNumber: _phoneNumber,
          limitAmount: _limitAmount
      ));

      //Display for the user that we sent an email.
    } catch (e) {
      print(e.message());
    }
  }
  //Sign out
  Future signOut() async {
    if (user != null) {
      try {
        return await _auth.signOut();
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }

  Future resetPassword(String email) async{
    try {
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.message());
      return null;
    }
  }
}
