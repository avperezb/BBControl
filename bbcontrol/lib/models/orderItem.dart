class OrderItem {

  String _id;
  String _productName;
  num _quantity;
  String _beerSize;
  num _price;

  OrderItem(this._productName,this._quantity,this._beerSize,this._price);
  OrderItem.withId(this._id,this._productName,this._quantity,this._beerSize,this._price);

  String get productName => _productName;
  num get quantity => _quantity;
  String get beerSize => _beerSize;
  num get price => _price;
  String get id => _id;

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

  OrderItem.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._productName = map['productName'];
    this._quantity = map['quantity'];
    this._beerSize = map['beerSize'];
    this._price = map['price'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['productName']= _productName;
    map['quantity']= _quantity;
    map['beerSize']= _beerSize;
    map['price'] = _price;
    return map;
  }

  OrderItem.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _productName = data['productName'],
        _quantity = data['quantity'],
        _beerSize = data['beerSize'],
        _price = data['price'];

  Map<String, dynamic> toJson(){
    return{
      'id': _id,
      'productName': _productName,
      'quantity' : _quantity,
      'beerSize' : _beerSize,
      'price' : _price
    };
  }
}
