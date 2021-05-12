import 'package:flutter/material.dart';
import 'main.dart';

Widget getCPB() {
  return CircularProgressIndicator();
}

// main parent widget
class MyParent extends StatefulWidget {
  final IconData iconData;
  final String meText;

  MyParent({this.meText, this.iconData});

  @override
  _MyParentState createState() => _MyParentState();
}

class _MyParentState extends State<MyParent> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeInCirc);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(widget.iconData, size: 110.0, color: Colors.white),
          SizedBox(
            height: 40.0,
          ),
          MyBody(
            myText: widget.meText,
          )
        ],
      ),
    );
  }
}



// main body of widget
class MyBody extends StatelessWidget {
  final String myText;

  MyBody({this.myText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          myText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
