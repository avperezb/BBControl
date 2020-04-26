
class Order{

  String _id;
  String _idWaiter;
  String _idUser;
  DateTime _created;

  Order.withId(this._id,this._idWaiter,this._idUser,this._created);
  Order(this._idWaiter,this._idUser,this._created);

  String get id => _id;
  String get idWaiter => _idWaiter;
  String get idUser => _idUser;
  DateTime get created => _created;

  Order.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _idWaiter = data['idWaiter'],
        _idUser = data['idUser'],
        _created = data['created'];

  Map<String, dynamic> toJson(){
    return{
      'id' : _id,
      'idWaiter': _idWaiter,
      'idUser': _idUser,
      'created' : _created
    };
  }
}