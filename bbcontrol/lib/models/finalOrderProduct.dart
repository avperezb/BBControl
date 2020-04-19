class FinalOrderProduct {

  String _id;
  String _productName;
  num _quantity;
  String _beerSize;
  num _price;
  String _foodComments;

  FinalOrderProduct(this._id, this._productName,this._quantity,this._beerSize,this._price,this._foodComments);
  FinalOrderProduct.withId(this._id, this._productName,this._quantity,this._beerSize,this._price,this._foodComments);

  String get id => _id;
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

  FinalOrderProduct.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _productName = data['productName'],
        _quantity = data['quantity'],
        _beerSize = data['beerSize'],
        _price = data['price'],
        _foodComments = data['foodComments'];

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
