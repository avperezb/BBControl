class Reservation {

  DateTime _date;
  DateTime _startTime;
  DateTime _endTime;
  int _tableNumber;

  Reservation(this._date, this._endTime, this._startTime, this._tableNumber);

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
        _date = data['date'],
        _startTime = data['start'],
        _endTime = data['end'],
        _tableNumber = data['table_number'];

  Map<String, dynamic> toJson(){
    return{
      'date' : _date,
      'start' : _startTime,
      'end' : _endTime,
      'table_number' : _tableNumber
    };
  }
}
