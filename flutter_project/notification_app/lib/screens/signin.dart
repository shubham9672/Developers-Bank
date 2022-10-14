import 'package:dev_task/auth_service/auth_service.dart';
import 'package:dev_task/components/constants.dart';
import 'package:dev_task/screens/signup.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  String email = " ", password = " ";
  Color blueColor = const Color.fromARGB(255, 51, 128, 180);

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
              child: buildSigninForm(),
            ),
          ),
        ),
      ),
      extendBody: true,
    );
  }

  buildSigninForm() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ignore: sized_box_for_whitespace
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              Icon(Icons.ac_unit_sharp),
              Text(
                'Sign In To Continue',
                style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: textFont,
                    color: Colors.grey[800]),
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
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => const reset()));
                },
                child: Container(
                  alignment: const Alignment(1.0, 0.0),
                  padding: const EdgeInsets.only(top: 15, left: 20.0),
                  child: InkWell(
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 15.0,
                        fontFamily: textFont,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    if (checkFields()) {
                      AuthService().signin(email, password, context);
                    }
                  },
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(50),
                      shadowColor: blueColor,
                      color: blueColor,
                      elevation: 0,
                      child: const Center(
                        child: const Text(
                          'Login',
                          style: const TextStyle(
                              fontFamily: textFont,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New To Track EZ ',
                      style:
                          const TextStyle(fontSize: 16, fontFamily: textFont)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: textFont,
                        color: blueColor,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
