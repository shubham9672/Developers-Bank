// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class LetterGrid extends StatelessWidget {
  final index;
  final onpress;
  const LetterGrid({Key? key, required this.index, required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.purple[50],
        child: SizedBox(
          width: 35,
          height: 35,
          child: MaterialButton(
            onPressed: onpress,
            child: Text(
              index,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
