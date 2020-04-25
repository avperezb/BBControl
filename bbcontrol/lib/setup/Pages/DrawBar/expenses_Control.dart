import 'package:flutter/material.dart';

class ExpensesControlPage extends StatefulWidget {
  @override
  _ExpensesControlPageState createState() => _ExpensesControlPageState();
}

class _ExpensesControlPageState extends State<ExpensesControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Control'),
        backgroundColor: const Color(0xFFAD4497),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:
        ListView(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Text('First name: ',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
