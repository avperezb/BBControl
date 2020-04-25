class Reservation {

  DateTime _date;
  DateTime _startTime;
  DateTime _endTime;
  int _numPeople;
  List<String> _preferences;
  String _userId;

  Reservation(this._date, this._endTime, this._startTime, this._numPeople, this._preferences, this._userId);

  DateTime get date => _date;
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;
  int get numPeople => _numPeople;
  List<String> get preferences => _preferences;
  String get userId => _userId;

  set userId(String userId){
    this._userId = userId;
  }
  set date(DateTime date){
    this._date = date;
  }
  set startTime(DateTime startTime){
    this._startTime = startTime;
  }
  set endTime(DateTime endTime){
    this._endTime = endTime;
  }
  set numPeople(int numPeople){
    this._numPeople = numPeople;
  }
  set preferences(List<String> preferences){
    this._preferences = preferences;
  }

  Reservation.fromData(Map<String, dynamic> data):
        _date = data['date'],
        _startTime = data['start'],
        _endTime = data['end'],
        _numPeople = data['num_people'],
        _preferences = data['preferences'],
        _userId = data['user_Id'];

  Map<String, dynamic> toJson(){
    return{
      'date' : _date,
      'start' : _startTime,
      'end' : _endTime,
      'num_people' : _numPeople,
      'preferences' : _preferences,
      'user_Id' : _userId
    };
  }
}
