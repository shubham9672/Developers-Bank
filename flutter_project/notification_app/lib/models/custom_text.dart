import 'package:dev_task/components/constants.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String data;
  String ff;
  Color c;
  bool softWrap;
  bool overFlow;
  MyText(
      {Key? key,
      required this.data,
      this.ff = textFont,
      this.c = textColor,
      this.softWrap = false,
      this.overFlow = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      softWrap: softWrap,
      style: TextStyle(
          color: c,
          fontFamily: textFont,
          overflow: overFlow ? TextOverflow.ellipsis : TextOverflow.fade),
    );
  }
}
