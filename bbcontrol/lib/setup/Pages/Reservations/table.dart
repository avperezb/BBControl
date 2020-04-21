import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleTable extends StatefulWidget {
  int seats;
  bool available;
  bool selected;
  int tableNumber;
  Function(int, SingleTable) callback;
  SingleTable(int seats, bool available, int tableNumber, Function callback){
    this.seats = seats;
    this.available = available;
    selected = false;
    this.callback = callback;
    this.tableNumber = tableNumber;
  }

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<SingleTable> {
  @override
  void initState() {
    color = (widget.available) ? Colors.brown[600] : Colors.grey[600];
    super.initState();
  }
  var icons = {
    1 : Icons.looks_two,
    2 : Icons.looks_two,
    3 : Icons.looks_3,
    4 : Icons.looks_4
  };
  var color;
  bool selected = false;
  bool previousState = false;

  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          icons[widget.seats],
          color: color,
          size:40,
        ),
        onPressed: () {
          setState(() {
            previousState = selected;
            selected = !selected;
            //     color = (selected) ? const Color(0xFF69B3E7) : Colors.brown[600];
            widget.callback(widget.seats, widget);
          });
        });
  }
}


