
import 'package:bbcontrol/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uId: user.uid) : null;
  }

  //Auth change user stream
  Stream<User> get user{
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
  Future signUp(String _email, String _password) async{
      try{
        FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: _email, password: _password)).user;
        user.sendEmailVerification();
        return _userFromFirebaseUser(user);
        //Display for the user that we sent an email.
      }catch(e) {
        print(e.message);
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