import 'package:fingerprint/hompage.dart';
import 'package:fingerprint/locanauth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: ()async{
              final isavailable=await LocalAuthApi.hasBiometrics(); //create bool true if your device support biometric
              final biometrics=await LocalAuthApi.getBiometrics();
               final hasfingerprint1=  biometrics.contains(BiometricType.fingerprint); //create bool true if your device support fingerprint
              showDialog(context: context, builder: (context)=>AlertDialog( //show alert dialog 
                title: Text("Available in device"),
                content: Column(
                  children:[
                    ListTile(title: Text("Biometrics"),leading: isavailable?Icon(Icons.check):Icon(Icons.close)), //show biometric available or not in your device
                    ListTile(title: Text("Fingerprint"),leading: hasfingerprint1?Icon(Icons.check):Icon(Icons.close))//show fingerprint available or not in your device
                  ]
                ),
              ));

            }, child: Text("Biometrics available to your device")),
            ElevatedButton(onPressed: ()async{
              final isauthenticated=await LocalAuthApi.authenticate(); //check if you are orized or not based on fingerprint
              if(isauthenticated){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage())); //change page to homepage if you are authorized
              }
            }, child: Text('authenticate'))
          ],
        ),
      ),

    );
  }
}
