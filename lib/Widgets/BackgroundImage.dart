import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
            Image.asset(
              'assets/background.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}