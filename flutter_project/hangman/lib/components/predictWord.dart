// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';

class PredLetterGrid extends StatelessWidget {
  final letter;
  const PredLetterGrid({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 60,
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.deepPurpleAccent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  letter,
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: const Text(
                  '___',
                  style: TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
