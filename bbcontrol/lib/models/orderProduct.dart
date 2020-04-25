class OrderProduct {

  String _id;
  String _productName;
  num _quantity;
  String _beerSize;
  num _price;
  String _foodComments;
  String _userId;
  num _status;
  String _waiterId;

  OrderProduct(this._productName,this._quantity,this._beerSize,this._price,this._foodComments, this._userId, this._status, this._waiterId);
  OrderProduct.withId(this._id,this._productName,this._quantity,this._beerSize,this._price,this._foodComments, this._userId, this._status, this._waiterId);

  String get userId => _userId;
  String get productName => _productName;
  num get quantity => _quantity;
  String get beerSize => _beerSize;
  num get price => _price;
  String get foodComments => _foodComments;
  String get id => _id;
  num get status => _status;
  String get waiterId => _waiterId;

  set userId(String userId){
    this._userId = userId;
  }

  set productName(String newProductName){
    this._productName = newProductName;
  }

  set quantity(num newQuantity){
    this._quantity = newQuantity;
  }

  set beerSize(String newBeerSize){
    this._beerSize = newBeerSize;
  }

  set price(num newPrice){
    this._price = newPrice;
  }

  set foodComments(String newComments){
    this._foodComments = newComments;
  }

  set status(num pstatus){
    this._status = pstatus;
  }

  set waiterId(String waiterID){
    this._waiterId = waiterID;
  }

  OrderProduct.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._productName = map['productName'];
    this._quantity = map['quantity'];
    this._beerSize = map['beerSize'];
    this._price = map['price'];
    this._foodComments = map['foodComments'];
    this._userId = map['user_id'];
    this._status = map['status'];
    this._waiterId = map['waiter_id'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['productName']= _productName;
    map['quantity']= _quantity;
    map['beerSize']= _beerSize;
    map['price'] = _price;
    map['foodComments']= _foodComments;
    map['user_id'] = _userId;
    map['status'] = _status;
    map['waiter_id'] = _waiterId;

    return map;
  }

  OrderProduct.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _productName = data['productName'],
        _quantity = data['quantity'],
        _beerSize = data['beerSize'],
        _price = data['price'],
        _foodComments = data['foodComments'],
        _userId = data['user_id'],
        _status = data['status'],
        _waiterId = data['waiter_id'];

  Map<String, dynamic> toJson(){
    return{
      'id': _id,
      'productName': _productName,
      'quantity' : _quantity,
      'beerSize' : _beerSize,
      'price' : _price,
      'foodComments' : _foodComments,
      'user_id' : _userId,
      'status' : _status,
      'waiter_id' : _waiterId
    };
  }
}
