import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemTwoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Item 2',
          style: TextStyle(
              color: Color(0xffF6265A),
              fontWeight: FontWeight.bold,
              fontSize: 30.0),
        ),
      ),
    );
  }
}
