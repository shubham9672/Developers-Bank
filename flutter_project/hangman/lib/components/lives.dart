// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Lives extends StatelessWidget {
  final int lives;
  const Lives({Key? key, required this.lives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
      child: Row(
        children: [
          Text(
            'Lives  ',
            style: TextStyle(color: Colors.greenAccent, fontSize: 25),
          ),
          for (var i = 0; i < lives; i++)
            Icon(
              Icons.favorite,
              color: Colors.red,
            )
        ],
      ),
    );
  }
}
