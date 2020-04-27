import 'package:bbcontrol/models/orderItem.dart';

class OrderAndItems {

  DateTime created;
  num total;
  String idWaiter;
  List<OrderItem> orders;

  OrderAndItems({this.created,this.total,this.idWaiter, this.orders});

}