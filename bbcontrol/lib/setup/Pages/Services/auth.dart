import 'package:bbcontrol/models/customer.dart';
import 'package:bbcontrol/setup/Pages/Services/customers_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CustomersFirestoreClass _firestoreService = CustomersFirestoreClass();
  //Create object based on FirebaseUser
  Customer _userFromFirebaseUser(FirebaseUser user){
    return user != null ? Customer(id: user.uid) : null;
  }

  //Auth change user stream
  Stream<Customer> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  //Sign in email-password
  Future signIn(String _email, String _password) async{
      try{
        FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: _email, password: _password)).user;
        return _userFromFirebaseUser(user);
      }catch(e) {
        print(e.message);
        return null;
    }
  }

  //Register email-password
  Future signUp(String _email, String _password, String _fullName, num _phoneNumber, DateTime _birthDate) async{
      try{
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        user.sendEmailVerification();
      await _firestoreService.createCustomer(Customer(
        id:  user.uid,
        email: _email,
        fullName: _fullName,
        birthDate: _birthDate,
        phoneNumber: _phoneNumber
      ));
    return _userFromFirebaseUser(user);
        //Display for the user that we sent an email.
      }catch(e) {
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

}