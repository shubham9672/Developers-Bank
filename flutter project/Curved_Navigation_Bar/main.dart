import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index=1;
final items=<Widget>[ //list of icon used in navigation bar
  Icon(Icons.home,size: 35),
  Icon(Icons.logout,size: 35),
  Icon(Icons.settings,size: 35),
  Icon(Icons.place,size: 35),
  Icon(Icons.account_circle,size: 35),


];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      bottomNavigationBar:Theme(
        data:Theme.of(context).copyWith(iconTheme: IconThemeData(color: Colors.black)) ,
        child:
      CurvedNavigationBar( //Adding widget Curved Naviagtion Bar
        color: Colors.cyanAccent, //set color of navigation bar
        buttonBackgroundColor: Colors.purpleAccent, //Set color of current icon
        backgroundColor: Colors.transparent, //set transpparent to show uplift effect of icon on page
        height: 70,
        index: index,
        onTap: (index)=>setState(()=>this.index=index), //change index no on tap on icon
        items:items, //add list of icon 
      ),
      ),
        body: Center(
    child: Text('$index',//show the current index number
    style: TextStyle(
      fontWeight:FontWeight.bold,
      fontSize: 40,
    ),),
    ),
     );
  }
}
