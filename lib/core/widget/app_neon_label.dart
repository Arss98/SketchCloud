import 'package:flutter/material.dart'; 

final class AppNeonLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color; 
  final List<Shadow> shadows;

  const AppNeonLabel ({
    super.key,
    required this.text,
    this.fontSize = 20,
    this.color = Colors.white,
    this.shadows = const [
      Shadow(
        color: Colors.blueAccent,
        blurRadius: 15.0,
        offset: Offset(0, 0),
      ),
      Shadow(
        color: Colors.blueAccent,
        blurRadius: 30.0,
        offset: Offset(0, 0),
      ),
      Shadow(
        color: Colors.purple, 
        blurRadius: 40.0,
        offset: Offset(0, 0),
      ),
    ] 
  }); 

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'PressStart2P',
        fontSize: fontSize,
        color: color,
        shadows: shadows,
      ),
    );
  }
}