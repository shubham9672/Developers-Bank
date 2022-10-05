// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hangman/components/letter.dart';
import 'package:hangman/components/lives.dart';
import 'package:hangman/components/predictWord.dart';
import 'package:hangman/pages/home.dart';
import 'dart:math';

class Game extends StatefulWidget {
  final int level;
  const Game({Key? key, required this.level}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  List<bool> pressed = [];
  List<String> EasyWords = [
    'BOX',
    'ROAD',
    'PAINT',
    'GAME',
    'JUMP',
    'THROW',
    'MOBILE'
  ];
  List<String> MediumWords = [
    'TELIVISION',
    'MANAGER',
    'GEOGRAPHY',
    'POLITICS',
    'JUGGLE',
    'NATIVE',
    'NEIGHBOUR'
  ];
  List<String> HardWords = [
    'OR',
    'KINKY',
    'KNOB',
    'SOCKET',
    'CRYSTAL',
    'SUSPENSE',
    'MICROPHONE'
  ];

  int lives = 6;
  int hangstate = 0;
  int temp_size = 0;
  int hints = 1;
  String word = '';
  List pressalpha = [];
  List predletter = [];
  Widget Alphabutton(index) {
    return LetterGrid(
      index: alphabet[index],
      onpress: pressed[index] == false ? () => onpress(index) : null,
    );
  }

  void Hints() {
    if (hints == 1 && temp_size != word.length - 1 && word.length > 4) {
      for (var i = 0; i < word.length; i++) {
        if (predletter[i] == '') {
          int index = alphabet.indexOf(word[i]);
          setState(() {
            predletter[i] = word[i];
            pressed[index] = true;
            hints = 0;
            temp_size += 1;
          });
          break;
        }
      }
    }
  }

  void WinGame() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
                child: Text(
              "Correct",
              style: TextStyle(color: Colors.greenAccent, fontSize: 25),
            )),
            children: <Widget>[
              Icon(
                Icons.done,
                size: 60,
                color: Colors.greenAccent,
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Play Again',
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 20)),
                  )),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (Context) => HomePage()),
                        (route) => false);
                  },
                  child: Text('Exit to Main Menu',
                      style:
                          TextStyle(color: Colors.greenAccent, fontSize: 20)),
                ),
              ),
            ],
          );
        });
  }

  void GameOver() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
                child: Text(
              "Game Over",
              style: TextStyle(color: Colors.greenAccent, fontSize: 25),
            )),
            children: <Widget>[
              Icon(
                Icons.not_interested_sharp,
                size: 60,
                color: Colors.red,
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Play Again',
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 20)),
                  )),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (Context) => HomePage()),
                        (route) => false);
                  },
                  child: Text('Exit to Main Menu',
                      style:
                          TextStyle(color: Colors.greenAccent, fontSize: 20)),
                ),
              ),
            ],
          );
        });
  }

  void WordRandomizer(List words) {
    int rand = Random().nextInt(words.length);
    setState(() {
      word = words[rand];
    });
  }

  onpress(int index) {
    if (lives == 0) {
      resetGame();
      GameOver();
    }
    if (temp_size == word.length) {
      resetGame();
      WinGame();
    }

    setState(() {
      pressalpha.add(alphabet[index]);
      pressed[index] = true;
    });
    bool check = false;
    for (int i = 0; i < word.length; i++) {
      if (alphabet[index] == word[i]) {
        check = true;
        setState(() {
          predletter[i] = word[i];
          temp_size += 1;
          if (temp_size == word.length - 1) {
            hints = 0;
          }
        });
      }
    }

    if (temp_size == word.length) {
      resetGame();
      WinGame();
    }
    if (!check) {
      setState(() {
        lives -= 1;
        hangstate += 1;
      });
      if (lives == 0) {
        resetGame();
        GameOver();
      }
    }
  }

  void init() {
    if (widget.level == 0) {
      WordRandomizer(EasyWords);
    } else if (widget.level == 1) {
      WordRandomizer(MediumWords);
    } else {
      WordRandomizer(HardWords);
    }
    setState(() {
      pressed = List.generate(26, (index) => false);
      predletter = List.generate(word.length, (index) => '');
      lives = 6;
      hangstate = 0;
      temp_size = 0;
      hints = 1;
    });
  }

  void resetGame() {
    init();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.deepPurple[700],
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Expanded(child: Lives(lives: lives)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(Icons.exit_to_app, color: Colors.greenAccent))
                ]),
                Image.asset(
                  'assets/$hangstate.png',
                  height: 250,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ...(predletter).map((i) {
                      return PredLetterGrid(letter: i);
                    }),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 2, 8, 10),
                  child: Column(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          TableRow(children: [
                            TableCell(
                              child: Alphabutton(0),
                            ),
                            TableCell(
                              child: Alphabutton(1),
                            ),
                            TableCell(
                              child: Alphabutton(2),
                            ),
                            TableCell(
                              child: Alphabutton(3),
                            ),
                            TableCell(
                              child: Alphabutton(4),
                            ),
                            TableCell(
                              child: Alphabutton(5),
                            ),
                            TableCell(
                              child: Alphabutton(6),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Alphabutton(7),
                            ),
                            TableCell(
                              child: Alphabutton(8),
                            ),
                            TableCell(
                              child: Alphabutton(9),
                            ),
                            TableCell(
                              child: Alphabutton(10),
                            ),
                            TableCell(
                              child: Alphabutton(11),
                            ),
                            TableCell(
                              child: Alphabutton(12),
                            ),
                            TableCell(
                              child: Alphabutton(13),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Alphabutton(14),
                            ),
                            TableCell(
                              child: Alphabutton(15),
                            ),
                            TableCell(
                              child: Alphabutton(16),
                            ),
                            TableCell(
                              child: Alphabutton(17),
                            ),
                            TableCell(
                              child: Alphabutton(18),
                            ),
                            TableCell(
                              child: Alphabutton(19),
                            ),
                            TableCell(
                              child: Alphabutton(20),
                            ),
                          ]),
                          TableRow(children: [
                            TableCell(
                              child: Text(''),
                            ),
                            TableCell(
                              child: Alphabutton(21),
                            ),
                            TableCell(
                              child: Alphabutton(22),
                            ),
                            TableCell(
                              child: Alphabutton(23),
                            ),
                            TableCell(
                              child: Alphabutton(24),
                            ),
                            TableCell(
                              child: Alphabutton(25),
                            ),
                            TableCell(
                              child: Text(''),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.deepPurple,
          child: Row(
            children: [
              Expanded(
                  child: MaterialButton(
                elevation: 10,
                height: 1,
                onPressed: hints == 1 && word.length > 4
                    ? () {
                        setState(() {
                          Hints();
                        });
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.highlight_rounded,
                        color: Colors.greenAccent,
                      ),
                      Text(
                        'Hints',
                        style: TextStyle(color: Colors.greenAccent),
                      )
                    ],
                  ),
                ),
                color: Colors.deepPurpleAccent,
              )),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: MaterialButton(
                elevation: 10,
                height: 1,
                onPressed: () {
                  setState(() {
                    resetGame();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.replay_outlined,
                        color: Colors.greenAccent,
                      ),
                      Text(
                        'Reset Game',
                        style: TextStyle(color: Colors.greenAccent),
                      )
                    ],
                  ),
                ),
                color: Colors.deepPurpleAccent,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
