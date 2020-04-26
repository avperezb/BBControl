
class Order{

  final String id;
  final String idWaiter;
  final String idUser;
  final DateTime created;

  Order.withId(this.id,this.idWaiter,this.idUser,this.created);

  Order({
    this.id,
    this.idWaiter,
    this.idUser,
    this.created
  });

  Order.fromData(Map<String, dynamic> data):
        id = data['id'],
        idWaiter = data['idWaiter'],
        idUser = data['idUser'],
        created = data['created'];

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'idWaiter': idWaiter,
      'idUser': idUser,
      'created' : created
    };
  }
}