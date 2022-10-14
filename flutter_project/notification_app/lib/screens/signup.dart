import 'package:dev_task/auth_service/auth_service.dart';
import 'package:dev_task/components/constants.dart';
import 'package:dev_task/screens/signin.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  late String email, password, name;
  Color blueColor = const Color.fromARGB(255, 1, 98, 163);

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
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formKey,
              child: buildsignUpform(),
            ),
          ),
        ),
      ),
    );
  }

  buildsignUpform() {
    return Column(
      children: [
        // ignore: sized_box_for_whitespace
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              Icon(Icons.ac_unit),
              Text(
                'Sign Up To Continue',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: textFont,
                    fontSize: 25.0),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(fontFamily: textFont),
                  cursorHeight: 20,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'John Doe',
                      hintStyle:
                          TextStyle(color: textColor, fontFamily: textFont),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: blueColor),
                      )),
                  onChanged: (value) {
                    // ignore: unnecessary_this
                    this.name = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: TextStyle(fontFamily: textFont),
                    cursorHeight: 20,
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'John@example.com',
                        hintStyle:
                            TextStyle(color: textColor, fontFamily: textFont),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blueColor),
                        )),
                    onChanged: (value) {
                      // ignore: unnecessary_this
                      this.email = value;
                    },
                    validator: (value) => value!.isEmpty
                        ? 'Email Required '
                        : validateEmail((value))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    style: TextStyle(fontFamily: textFont),
                    cursorHeight: 20,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(color: textColor, fontFamily: textFont),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: blueColor),
                        )),
                    obscureText: true,
                    onChanged: (value) {
                      // ignore: unnecessary_this
                      this.password = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Password is required' : null),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (checkFields()) {
                      AuthService().signUp(email, password, name);
                      Navigator.of(context).pop();
                    }
                  },
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 50,
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      shadowColor: Colors.lightBlueAccent,
                      color: blueColor,
                      elevation: 0,
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontFamily: textFont,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignInPage()));
            },
            child: Text(
              'Already have a account?',
              style: TextStyle(
                fontFamily: textFont,
                color: blueColor,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )
      ],
    );
  }
}
