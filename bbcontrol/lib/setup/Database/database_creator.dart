import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Reservation {

  int id;
  bool matchMode;
  int seats;
  DateTime startDate;
  DateTime endDate;
  String user;

  Reservation(int id, bool matchMode, int seats, DateTime startDate, DateTime endDate, String user){
    this.id = id;
    this.matchMode = matchMode;
    this.seats = seats;
    this.startDate = startDate;
    this.endDate = endDate;
    this.user = user;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "seats": seats,
      "startDate": startDate,
      "endDate": endDate,
      "user": user,
    };
  }

  Reservation.fromMap(Map<String, dynamic> map){
    id = map['id'];
    matchMode = map['matchMode'];
    seats = map['seats'];
    startDate = map['startDate'];
    endDate = map['endDate'];
    user = map['user'];
  }
}

class ReservationDatabase{

  Database _db;

  Future initDB() async {
    _db = await openDatabase('reservations_database.db',
      version: 1, onCreate: (Database db, int version){
        db.execute("CREATE TABLE reservations (id INTEGER PRIMARY KEY, matchMode BOOLEAN, seats INTEGER, startDate DATE, endDate DATE, user TEXT);"
        );
      },
    );
  }

  Future<void> insert(Reservation reservation) async{
    _db.insert("reservations", reservation.toMap());
    print(await _db.insert("reservations", reservation.toMap()));
  }

  Future<List<Reservation>> getAllReservations() async {
    List<Map<String, dynamic>>results = await _db.query("reservations");
    print("Got: ${results.length}");
    return results.map((map) => Reservation.fromMap(map)).toList();
  }
}