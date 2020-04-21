import 'package:bbcontrol/setup/Pages/Services/reservations_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bbcontrol/setup/Pages/Reservations/reservationsAux.dart' as res;

class ReserveTable extends StatefulWidget {
  res.Table table;
  ReservationsFirestoreClass _reservationsFirestoreClass = ReservationsFirestoreClass();
  ReserveTable(res.Table table){
    this.table = table;
  }
  @override
  _ReserveTableState createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable> {
  DateTime _date;
  DateTime _startTime;
  TimeOfDay _startNoFormat;
  DateTime _endTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reserve table',),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B00),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(15, MediaQuery.of(context).size.height*.43, 15, 15),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            color: const Color(0xFFD7384A),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
              }
            },
            child: Text('Reserve table',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
                child: Text('Table ${widget.table.tableNumber}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: DateTimeField(
                    validator: (input) {
                      if (input == null) {
                        return 'Please enter your birth date';
                      }
                      else{
                        if(!input.isBefore(new DateTime.now())){
                          return  'Not a valid date';
                        }
                      }
                    },
                    format: formatDate,
                    decoration:const InputDecoration(
                        icon: const Icon(Icons.calendar_today,
                            color: const Color(0xFFD8AE2D)
                        ),
                        labelText: 'Reservation date'
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    onSaved: (input) => _date = input
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: DateTimeField(
                    validator: (input) {
                      if (input == null) {
                        return 'Please select a time';
                      }
                    },
                    format: formatHour,
                    decoration:const InputDecoration(
                        icon: const Icon(Icons.watch_later,
                            color: const Color(0xFFD8AE2D)
                        ),
                        labelText: 'Starting time'
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      _startNoFormat = time;
                      return DateTimeField.convert(time);
                    },
                    onSaved: (input) => {_startTime = input},
                  ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: DateTimeField(
                  validator: (input) {
                    if (input == null) {
                      return 'Please select a time';
                    }
                  },
                  format: formatHour,
                  decoration:const InputDecoration(
                      icon: const Icon(Icons.access_time,
                          color: const Color(0xFFD8AE2D)
                      ),
                      labelText: 'Ending time'
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startNoFormat,
                    );
                    print(time.hour);
                    return DateTimeField.convert(time);
                  },
                  onSaved: (input) => _endTime = input,
                ),
              ),
            ],
          ),
        )
    );
  }
}
