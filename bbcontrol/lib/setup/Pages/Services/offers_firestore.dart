import 'package:bbcontrol/models/offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OffersFirestoreClass {

  final String id;
  bool done = false;
  OffersFirestoreClass({this.id});

  final CollectionReference _offersCollectionReference = Firestore.instance.collection('Promotions');


  Future addOffer(Offer offer) async {
    String message = '';
    try {
      print(offer.toJson());
      await _offersCollectionReference.document(offer.id).setData(
          offer.toJson());
    } catch (e) {
      message = e.message;
    }
    if(message.length==0){
      done = true;
    }
    else{
      done = false;
    }
  }

  Future updateOfferStatus(String idOffer, bool status) async {
    try {
      await _offersCollectionReference.document(idOffer).updateData({
        'active': status
      });
    }catch(e){
      return e.message;
    }
  }

  Future updateOffer(Offer offer) async{
    try {
      await _offersCollectionReference.document(offer.id).setData({
        'id' : offer.id,
        'description': offer.description,
        'active': offer.active,
        'price' : offer.price,
        'name' : offer.name,
      });
    }catch(e){
      return e.message;
    }
  }

  bool getOperationStatus(){
    return done;
  }

}