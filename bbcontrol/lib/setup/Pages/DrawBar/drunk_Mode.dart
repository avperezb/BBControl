import 'dart:math';

import 'package:bbcontrol/setup/Pages/Extra/ColorLoader.dart';
import 'package:bbcontrol/setup/Pages/Extra/DotType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location.dart';
import 'math_Operation.dart';

class DrunkModePage extends StatefulWidget {
  @override
  _DrunkModePageState createState() => _DrunkModePageState();
}

class _DrunkModePageState extends State<DrunkModePage> {

  initState() {
    // TODO: implement initState
    if (isSwitched == null) {
      obtenerEstadoDrunkMode();
    }
    super.initState();
  }

  LocationClass lc = LocationClass();
  bool isSwitched = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  MathOperation mathOperation = MathOperation();
  int correctAnswer;
  int userAnswer;
  List<String> operationText;
  List<int> posiblesOpciones;
  int op1;
  int op2;
  int op3;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
        title: Text('Drunk Mode'),
        centerTitle: true,
        backgroundColor: const Color(0xFFAD4497),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child:
        ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Icon(Icons.no_encryption,
                        color: Colors.blueGrey),
                    Container(
                      width: 200,
                      margin: EdgeInsets.fromLTRB(10, 20, 0, 20),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text('Enable drunk mode',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) async {
                        print('hacen switch drunk mode:');
                        print(value);
                        await guardarEstadoDrunkMode(value);
                        //se actualiza de una vez la ubicación actual
                        lc.isNearBBC();
                        if (!isSwitched) {
                          setState(() {
                            isSwitched = value;
                          });
                        }
                        else {
                         showMathOperation();
                        }
                      },
                      activeTrackColor: Color(0xFFC591BA),
                      activeColor: Color(0xFF8B2275),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              height: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                        leading: Icon(Icons.warning, size: 40),
                        title: Text('What\'s this?', style: TextStyle(color: Colors.black))
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 90),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text("We are here to protect you from making mistakes."
                          "When you\'re drunk enough some functionalities will be disabled. "
                          "Anyway, you can switch it off whenever you want to, as long as you pass our test!",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text("Have a great time at BBC!",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                  ],
                ),
              ),),
          ],
        ),
      ),
    );
  }

  void showMathOperation(){

    operationText = mathOperation.operation();
    posiblesOpciones = mathOperation.calculateResult(operationText);
    correctAnswer = posiblesOpciones[2];
    op1 = posiblesOpciones[mathOperation.randomNumber(0, 2)];
    posiblesOpciones.remove(op1);
    op2 = posiblesOpciones[mathOperation.randomNumber(0, 1)];
    posiblesOpciones.remove(op2);
    op3 = posiblesOpciones[0];
    posiblesOpciones.remove(op3);
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text(
                  'Select the correct answer'),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment
                    .start,
                children: <Widget>[
                  textOfDialog(operationText),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op1) {
                      setState(() {
                        isSwitched = !isSwitched;
                        guardarEstadoDrunkMode(isSwitched);
                        cambiarCantOrdenes(0);
                      });
                      Navigator.of(context).pop();
                      showSnackBarRight();
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBarWrong();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op1.toString()),
                ),
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op2) {
                      setState(() {
                        isSwitched = !isSwitched;
                        guardarEstadoDrunkMode(isSwitched);
                        cambiarCantOrdenes(0);
                      });
                      Navigator.of(context).pop();
                      showSnackBarRight();
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBarWrong();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op2.toString()),
                ),
                FlatButton(
                  onPressed: () {
                    if (correctAnswer == op3) {
                      setState(() {
                        isSwitched = !isSwitched;
                        guardarEstadoDrunkMode(isSwitched);
                        cambiarCantOrdenes(0);
                      });
                      Navigator.of(context).pop();
                      showSnackBarRight();
                    }
                    else {
                      Navigator.of(context).pop();
                      showSnackBarWrong();
                    }
                  },
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(op3.toString()),
                ),
              ],
            )
    );
  }

  void obtenerEstadoDrunkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool("estadoDrunkMode");
    });
  }

  guardarEstadoDrunkMode(bool estadoActual)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("estadoDrunkMode", estadoActual);
  }

  cambiarCantOrdenes(int cantOrdenes)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("cantOrdenes", cantOrdenes);
  }

  void showSnackBarRight() {
    final snackBarContent = SnackBar(
      content: Text("Good answer! Drunk mode has been disabled.", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)),
      duration: Duration(days: 1),
      backgroundColor: Color(0xFF0CD46D),
      action: SnackBarAction(
          label: 'Dismiss',onPressed: _scaffoldkey.currentState.hideCurrentSnackBar,textColor: Color(0xFFF7F9F7)),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  void showSnackBarWrong() {
    final snackBarContent = SnackBar(
      content: Text("Wrong answer! Try again.", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)),
      duration: Duration(days: 1),
      backgroundColor: Color(0xFFDE5F54),
      action: SnackBarAction(
          label: 'Dismiss',onPressed: _scaffoldkey.currentState.hideCurrentSnackBar,textColor: Color(0xFFF7F9F7)),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }
}

Widget textOfDialog(List<String> resOperation) {
  return new RichText(
    text: new TextSpan(
      text: resOperation[0]+" "+resOperation[2].toString()+" "+resOperation[1].toString() +" = ?",
      style: const TextStyle(color: Colors.black87, fontSize: 17),
      children: <TextSpan>[
      ],
    ),
  );
}

Widget loaderFunction() {
  return ColorLoader5(
    dotOneColor: Colors.redAccent,
    dotTwoColor: Colors.blueAccent,
    dotThreeColor: Colors.green,
    dotType: DotType.circle,
    dotIcon: Icon(Icons.adjust),
    duration: Duration(seconds: 2),
  );
}

