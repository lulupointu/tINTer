import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';



void main() => runApp(MaterialApp(
  home: MyAppTest()
  ),
);

class MyAppTest extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppTest> with SingleTickerProviderStateMixin {
  Color color = Colors.red;
  AnimationController controller;
  Animation<double> animation;
  DateTime time;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          print('Changing...');
          // The state that has changed here is the animation object’s value.
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (animation.value==1) {
      print('duration: ' + (time.difference(DateTime.now())).toString());
    }
    print('Building');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          time = DateTime.now();
          setState(() {
            if (animation.value==0) {
              controller.forward();
            } else {
              controller.reverse();
            }
          });
        },
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          height: 200.0 + 200*animation.value,
          width: 200.0 + 200*animation.value,
        ),
      ),
    );
  }

}
