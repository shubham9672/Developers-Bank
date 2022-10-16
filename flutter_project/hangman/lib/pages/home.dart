// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hangman/pages/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'HangMan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.purple[50],
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Text(
                'Let\'s Play Hangman! ',
                style: TextStyle(fontSize: 40, color: Colors.deepPurpleAccent),
              ),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 20,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Game(
                                      level: 0,
                                    )));
                      },
                      color: Colors.deepPurple,
                      child: Text(
                        'Easy Mode',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 15,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Game(
                                      level: 1,
                                    )));
                      },
                      color: Colors.deepPurple,
                      child: Text(
                        'Medium Mode',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 10,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Game(
                                      level: 2,
                                    )));
                      },
                      color: Colors.deepPurple,
                      child: Text(
                        'Hard Mode',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
