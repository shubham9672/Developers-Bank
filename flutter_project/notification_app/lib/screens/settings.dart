import 'package:dev_task/auth_service/auth_service.dart';
import 'package:dev_task/components/constants.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: MaterialButton(
          color: primaryColor,
          child: MyText(
            data: 'SignOut',
            c: secondaryColor,
          ),
          onPressed: () {
            AuthService().signout();
          },
        ),
      ),
    );
  }
}
