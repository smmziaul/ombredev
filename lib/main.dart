import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ombredev/search_page.dart';
import 'tab_zero.dart';
import 'tab_one.dart';
import 'tab_two.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluttered Ombre',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firebaseInitiated = false;
  int _currentIndex = 0;
  final List<Widget> _children = [
    TabZero(),
    TabOne(),
    TabTwo(),
    SearchPage(),
  ];

  Widget getScaffold() {
    return Scaffold(
      body: _children[_currentIndex],
      backgroundColor: Colors.black87,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black87,
        color: Colors.grey,
        buttonBackgroundColor: Colors.pink,
        height: 55.0,
        animationDuration: Duration(milliseconds: 400),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Icon(Icons.wifi,
              size: this._currentIndex == 0 ? 44 : 22, color: Colors.white),
          Icon(Icons.add,
              size: this._currentIndex == 1 ? 44 : 22, color: Colors.white),
          Icon(Icons.list,
              size: this._currentIndex == 2 ? 44 : 22, color: Colors.white),
          Icon(Icons.search,
              size: this._currentIndex == 3 ? 44 : 22, color: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseInitiated) {
      return getScaffold();
    }
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Text("Something went wrong!"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          firebaseInitiated = true;
          return getScaffold();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Text("Loading..."),
        );
      },
    );
  }
}
