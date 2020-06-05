
class Offer{

  String _id;
  bool _active;
  String _description;
  String _name;
  num _price;

  Offer(this._id, this._active, this._description, this._name, this._price);

  String get id => _id;
  bool get active => _active;
  String get description => _description;
  String get name => _name;
  num get price => _price;

  set status(bool status){
    _active = status;
  }

  Offer.fromData(Map<String, dynamic> data, String id):
        _id = id,
        _description = data['active'],
        _active = data['active'],
        _price = data['price'],
        _name = data['name'];

  Map<String, dynamic> toJson(){
    return{
      'id' : _id,
      'description': _description,
      'active': _active,
      'price' : _price,
      'name' : _name,
    };
  }
}