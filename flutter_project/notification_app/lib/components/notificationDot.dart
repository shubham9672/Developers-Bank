import 'package:flutter/material.dart';

class NotificationDot extends StatelessWidget {
  final int dotNumer;
  const NotificationDot({Key? key, required this.dotNumer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight, child: Icon(Icons.notifications)),
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.circle,
              color: Colors.red[700],
              size: 10,
            ),
          ),
        ],
      ),
    );
  }
}
