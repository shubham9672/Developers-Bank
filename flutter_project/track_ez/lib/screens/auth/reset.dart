// ignore: duplicate_ignore
// ignore_for_file: camel_case_types, duplicate_ignore

import 'package:flutter/material.dart';

import '../../export.dart';

// ignore: camel_case_types
class reset extends StatefulWidget {
  const reset({Key? key}) : super(key: key);

  @override
  State<reset> createState() => _resetState();
}

class _resetState extends State<reset> {
  final formKey = GlobalKey<FormState>();

  late String email;
  Color greenColor = const Color.fromARGB(255, 51, 128, 180);

  checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validateEmail(String? value) {
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regExp.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formKey,
          child: _buildResetform(),
        ),
      ),
    );
  }

  _buildResetform() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 75.0,
            ),
            // ignore: sized_box_for_whitespace

            TextFormField(
                cursorHeight: 20,
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                        fontFamily: 'Trueno',
                        fontSize: 14,
                        color: Colors.blue.withOpacity(1)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: greenColor),
                    )),
                onChanged: (value) {
                  // ignore: unnecessary_this
                  this.email = value;
                },
                validator: (value) => value!.isEmpty
                    ? 'Email Required '
                    : validateEmail((value))),
            const SizedBox(
              height: 5.0,
            ),

            GestureDetector(
              onTap: () {
                if (checkFields()) {
                  AuthService().resetPass(
                    email,
                  );
                  Navigator.of(context).pop();
                }
              },
              // ignore: sized_box_for_whitespace
              child: Container(
                height: 50.0,
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  shadowColor: Colors.lightBlueAccent,
                  color: Colors.cyanAccent,
                  elevation: 0,
                  child: const Center(
                    child: Text(
                      'Reset',
                      style: TextStyle(fontFamily: 'Trueno', fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
