class Reservation {

  String _id;
  DateTime _date;
  DateTime _startTime;
  DateTime _endTime;
  int _tableNumber;

  Reservation(this._id, this._date, this._endTime, this._startTime, this._tableNumber);

  String get id => _id;
  DateTime get date => _date;
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;
  int get tableNumber => _tableNumber;

  set date(DateTime date){
    this._date = date;
  }
  set startTime(DateTime startTime){
    this._startTime = startTime;
  }
  set endTime(DateTime endTime){
    this._endTime = endTime;
  }
  set tableNumber(int tableNumber){
    this._tableNumber = tableNumber;
  }

  Reservation.fromData(Map<String, dynamic> data):
        _id = data['id'],
        _date = data['date'],
        _startTime = data['start'],
        _endTime = data['end'],
        _tableNumber = data['table_number'];

  Map<String, dynamic> toJson(){
    return{
      'id': _id,
      'date' : _date,
      'start' : _startTime,
      'end' : _endTime,
      'table_number' : _tableNumber
    };
  }
}
