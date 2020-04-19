

class OrderProduct {

  String _productName;
  num _quantity;
  String _beerSize;
  num _price;
  String _foodComments;

  OrderProduct(this._productName,this._quantity,this._beerSize,this._price,this._foodComments);
  OrderProduct.withId(this._productName,this._quantity,this._beerSize,this._price,this._foodComments);

  String get productName => _productName;
  num get quantity => _quantity;
  String get beerSize => _beerSize;
  num get price => _price;
  String get foodComments => _foodComments;

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

  OrderProduct.fromMapObject(Map<String, dynamic> map){
    this._productName = map['productName'];
    this._quantity = map['quantity'];
    this._beerSize = map['beerSize'];
    this._price = map['price'];
    this._foodComments = map['foodComments'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['productName']= _productName;
    map['quantity']= _quantity;
    map['beerSize']= _beerSize;
    map['price'] = _price;
    map['foodComments']= _foodComments;

    return map;
  }
}
