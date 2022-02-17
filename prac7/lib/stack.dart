import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stack extends StatefulWidget {
  @override
  _stackState createState() => _stackState();
}

class _stackState extends State<stack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stack'),
          backgroundColor: Theme.of(context).primaryColor,
        ), //AppBar
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 300,
                    color: Theme.of(context).primaryColor,
                  ), //Container
                  Container(
                    width: 250,
                    height: 250,
                    color: Color(0xfff76f91),
                  ), //Container
                  Container(
                    height: 200,
                    width: 200,
                    color: Color(0xfff7a6ba),
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    color: Color(0xfffad2dc),
                  ), //Container
                ], //<Widget>[]
              ), //Stack
            ), //Center
          ), //SizedBox
        ) //Center
        ); //Scaffold
  }
}
