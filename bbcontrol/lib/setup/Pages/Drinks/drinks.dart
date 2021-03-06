import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './nonAlcDrinks.dart';
import './alcoholicDrinks.dart';

class DrinksTabs extends StatefulWidget {
  String userId;
  DrinksTabs({userId}){
    this.userId = userId;
  }
  @override
  _DrinksTabsState createState() => _DrinksTabsState();
}

class _DrinksTabsState extends State<DrinksTabs> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drinks'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB75BA4),
      ),
      bottomNavigationBar: Material(
        color: const Color(0xFFB75BA4),
        child: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(
              icon: Icon(Icons.local_bar),
              text: 'Alcoholic',
            ),
            Tab(
              icon: Icon(Icons.local_drink),
              text: 'Non-alcoholic',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
         // AlcoholicDrinks(),
          AlcoholicDrinks(widget.userId),
          NonAlcoholicDrinks(widget.userId),
        ],
      ),
    );
  }
}

