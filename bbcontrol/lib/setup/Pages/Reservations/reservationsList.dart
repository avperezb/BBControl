import 'package:bbcontrol/Setup/Database/database_creator.dart';
import 'package:bbcontrol/Setup/Pages/Reservations/reservations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservationsList extends StatelessWidget {
  ReservationDatabase db = new ReservationDatabase();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today reservations'),
          centerTitle: true,
        backgroundColor: const Color(0xFFFF6B00),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            color: const Color(0xFF996480),
              child: Column(
                children: <Widget>[
                  Text('Table: 5',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text('Seats: 4',
                    style: TextStyle(
                      fontSize: 17
                  ),
                  ),
                  Text('Start hour: 4:00 pm',
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                  Text('End hour: 6:00 pm',
                    style: TextStyle(
                        fontSize: 17
                  ),
                  ),
                ],
              ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            color: const Color(0xFF996480),
            child: Column(
              children: <Widget>[
                Text('Table: 7',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text('Seats: 4',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('Start hour: 6:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
                Text('End hour: 8:00 pm',
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              ],
            ),

          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 250.0, 10.0, 0.0),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 13.0),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              color: const Color(0xFFD7384A),
              onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => Reservations()));},
              child: Text('Add new reservation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          ),
        ],
      ),
    );
  }

  showList(BuildContext bc) {
    return FutureBuilder(
      future: db.getAllReservations(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Reservation>> snapshot) {
        return ListView(
          children: <Widget>[
            for (Reservation reservation in snapshot.data)
              ListTile(title: Text(reservation.user))
          ],
        );
      },
    );
  }


}
/*return FutureBuilder(
future: db.initDB(),
builder: (BuildContext context, snapshot){
if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
return showList(context);
}else{
return Reservations();
 */



