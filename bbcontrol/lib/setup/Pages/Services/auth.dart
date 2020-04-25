import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomersFirestoreClass _firestoreService = CustomersFirestoreClass();
  Employee _currentCustomer;

  Future<String> getCurrentUserId() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userId = user.uid;
    return userId;
  }


    //Create object based on FirebaseUser
  Employee _userFromFirebaseUser(FirebaseUser user){
    return user != null ? Employee(id: user.uid, firstName: user.displayName) : null;
  }

  //Auth change user stream
  Stream<Employee> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //Sign in email-password
  Future signIn(String _email, String _password) async{
    print('log in');
      try{
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;
        print(_userFromFirebaseUser(user).toString()+'imprimiendo usuario creado');
        Employee customer = await _firestoreService.getCustomer(user.uid);
        print(customer);
        return customer;
      }catch(e) {
        print(e.message);
        return null;
    }
  }

  //Register email-password
  Future signUp(String _email, String _password, String _firstName, String _lastName, num _phoneNumber, DateTime _birthDate) async{
      try{
        print('holaaa');
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        user.sendEmailVerification();
      await _firestoreService.createCustomer(Employee(
        id:  user.uid,
        email: _email,
        firstName: _firstName,
        lastName: _lastName,
        birthDate: _birthDate,
        phoneNumber: _phoneNumber
      ));

       return user;
        //Display for the user that we sent an email.
      }catch(e) {
        print(e.message());
        return null;
    }
  }

  //Sign out
  Future signOut() async{
    if (user!= null) {
      try {
        return await _auth.signOut();
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }

  Future resetPassword(String email) async{
    return _auth.sendPasswordResetEmail(email: email);
  }

}