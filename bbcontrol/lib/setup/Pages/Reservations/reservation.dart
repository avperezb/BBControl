import 'package:bbcontrol/models/reservation.dart';
import 'package:bbcontrol/setup/Pages/Reservations/table.dart';
import 'package:bbcontrol/setup/Pages/Services/reservations_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Services/connectivity.dart';
import 'reservationsList.dart';

class MakeReservation extends StatefulWidget {

  @override
  _MakeReservationState createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  DateTime _date;
  DateTime _startTime;
  TimeOfDay _startNoFormat;
  DateTime _endTime;
  int _numPeople;
  bool _neartv = false;
  bool _nearbar = false;
  bool _neararcade = false;
  CheckConnectivityState checkConnection = CheckConnectivityState();
  bool cStatus = true;
  ReservationsFirestoreClass _reservationsFirestoreClass = ReservationsFirestoreClass();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formatDate = DateFormat("yMd");
  final formatHour = DateFormat("HH:mm a");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Make a reservation',),
          centerTitle: true,
          backgroundColor: const Color(0xFFD7384A),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height*.78,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                      child: Text('Reservation details',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: DateTimeField(
                          validator: (input) {
                            if (input == null) {
                              return 'Please enter a date';
                            }
                            else{
                              if(input.isBefore(new DateTime.now())){
                                return  'The minimum date is ${formatDate.format(DateTime.now().add(Duration(days: 1)))}';
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
                                initialDate: currentValue ?? DateTime.now().add(Duration(days: 1)),
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
                          else if(input.hour < 15){
                            return 'The minimum starting hour is 03:00 PM';
                          }
                        },
                        format: DateFormat("hh:mm a"),
                        decoration:const InputDecoration(
                            icon: const Icon(Icons.watch_later,
                                color: const Color(0xFFD8AE2D)
                            ),
                            labelText: 'Starting time'
                        ),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime(2020, 4, 22, 15)),
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
                          else if(input.difference((DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute)))
                              > Duration(hours: 3) || (DateTime(input.year, input.month, input.day, _startNoFormat.hour, _startNoFormat.minute))
                              .difference(input) > Duration(hours:  3)){
                            return 'A reservation can\'t last more than 3 hours';
                          }
                        },
                        format: DateFormat("hh:mm a"),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (input) {
                          if (input == null) {
                            return 'Please add a number';
                          }
                          if( num.parse(input) < 2 || num.parse(input) > 10){
                            return 'The number must be between 2 and 10 people';
                          }
                        },
                        decoration:const InputDecoration(
                            icon: const Icon(Icons.group,
                                color: const Color(0xFFD8AE2D)
                            ),
                            labelText: 'Number of people'
                        ),
                        onSaved: (input) => _numPeople = num.parse(input),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 30, 0, 30),
                      child: Text('Preferences',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                              color: _neararcade ? Color(0xFF69B3E7) : Colors.grey[300],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.videogame_asset,
                                      color: _neararcade ? Color(0xFFd2e8f7) : Colors.grey[700]),
                                  Text('Near arcade',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _neararcade ? Color(0xFFd2e8f7) : Colors.grey[700],
                                    ),
                                  )
                                ],
                              ),
                              onPressed: (){
                                setState(() {
                                  _neararcade = !_neararcade;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                                color: _neartv ? Color(0xFFD8AE2D) : Colors.grey[300],
                                onPressed: (){
                                  setState(() {
                                    _neartv = !_neartv;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.tv,
                                        color: _neartv ? Color(0xFFf7eed5) : Colors.grey[700]),
                                    Text('Near tv',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _neartv ? Color(0xFFf7eed5) : Colors.grey[700],
                                      ),)
                                  ],
                                )
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            child: RaisedButton(
                                color: _nearbar ? Color(0xFF996480) : Colors.grey[300],
                                onPressed: (){
                                  setState(() {
                                    _nearbar = !_nearbar;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(Icons.local_bar,
                                        color: _nearbar ? Color(0xFFd6c1cc) : Colors.grey[700]),
                                    Text('Near bar',
                                      style: TextStyle(
                                        color: _nearbar ? Color(0xFFd6c1cc) : Colors.grey[700],
                                      ),
                                      textAlign: TextAlign.center,)
                                  ],
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                color: const Color(0xFFD7384A),
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    showToast(context);
                    if(!cStatus) {
                      showOverlayNotification((context) {
                        return Card(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: SafeArea(
                            child: ListTile(
                              title: Text('Connection Error',
                                  style: TextStyle(fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)
                              ),
                              subtitle: Text(
                                'Check your connection and try again.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.close, color: Colors.white,),
                                  onPressed: () {
                                    OverlaySupportEntry.of(context)
                                        .dismiss();
                                  }),
                            ),
                          ),
                          color: Colors.blueGrey,);
                      }, duration: Duration(milliseconds: 4000));
                    }
                    else {
                      _formKey.currentState.save();
                      List<String> preferences = new List<String>();
                      if(_neararcade)  preferences.add('near arcade');
                      if(_nearbar) preferences.add(('near bar'));
                      if(_neartv) preferences.add('near tv');
                      Reservation reservation = new Reservation(
                          _date, _endTime, _startTime, _numPeople, preferences);
                      await _reservationsFirestoreClass.addReservation(reservation);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Confirm reservation',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void showToast(BuildContext context) async {
    await checkConnection.initConnectivity();
    setState(() {
      cStatus = checkConnection.getConnectionStatus(context);
      print(cStatus.toString()+'hhhhhhhhhhhhh');
    });
  }
}