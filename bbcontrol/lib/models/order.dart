
class Order{

  String _id;
  String _idWaiter;
  String _idUser;
  DateTime _created;
  String _state;
  num _total;
  num _limitAmount;
  List<String> _list;

  Order.withId(this._id,this._idWaiter,this._idUser,this._created, this._state, this._total, this._limitAmount, this._list);
  Order(this._idWaiter,this._idUser,this._created, this._state, this._total, this._limitAmount, this._list);

  String get id => _id;
  String get idWaiter => _idWaiter;
  String get idUser => _idUser;
  DateTime get created => _created;
  String get state => _state;
  num get total => _total;
  num get limitAmount => _limitAmount;
  List<String> get list => _list;

  Order.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _idWaiter = data['idWaiter'],
        _idUser = data['idUser'],
        _created = data['created'],
        _state= data['state'],
        _total = data['total'],
        _limitAmount = data['limitAmount'],
        _list = data['list'];

  Map<String, dynamic> toJson(){
    return{
      'id' : _id,
      'idWaiter': _idWaiter,
      'idUser': _idUser,
      'created' : _created,
      'state' : _state,
      'total' : _total,
      'limitAmount' : _limitAmount,
      'list': _list
    };
  }
}