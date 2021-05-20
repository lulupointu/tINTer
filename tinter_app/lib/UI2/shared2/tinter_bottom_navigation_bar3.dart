import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar3 extends StatefulWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;
  final GlobalKey discoverIconKey;

  const CustomBottomNavigationBar3(
      {Key key,
      @required this.onTap,
      @required this.selectedIndex,
      @required this.discoverIconKey})
      : super(key: key);

  @override
  _CustomBottomNavigationBar3State createState() =>
      _CustomBottomNavigationBar3State();
}

class _CustomBottomNavigationBar3State
    extends State<CustomBottomNavigationBar3> {
  var selection = [0, 0, 1]; // Match, Discover, Profile
  Duration duration = Duration(milliseconds: 300);

  double circleMatchDiameter = 0;
  double circleDiscoverDiameter = 0;
  double circleProfileDiameter = 44;

  Color matchColor = Color(0xff79BFC9);
  Color discoverColor = Color(0xff79BFC9);
  Color profileColor = Colors.white;

  void onProfileClicked() {
    setState(() {
      matchColor = Color(0xff79BFC9);
      discoverColor = Color(0xff79BFC9);
      profileColor = Colors.white;
      circleMatchDiameter = 0;
      circleDiscoverDiameter = 0;
      circleProfileDiameter = 44;
    });
  }

  void onDiscoverClicked() {
    setState(() {
      matchColor = Color(0xff79BFC9);
      discoverColor = Colors.white;
      profileColor = Color(0xff79BFC9);
      circleMatchDiameter = 0;
      circleDiscoverDiameter = 44;
      circleProfileDiameter = 0;
    });
  }

  void onMatchClicked() {
    setState(() {
      matchColor = Colors.white;
      discoverColor = Color(0xff79BFC9);
      profileColor = Color(0xff79BFC9);
      circleMatchDiameter = 44;
      circleDiscoverDiameter = 0;
      circleProfileDiameter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    selection = [0, 0, 0];
    selection[widget.selectedIndex] = 1;

    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(
            0.95,
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: duration,
                  height: circleMatchDiameter,
                  width: circleMatchDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: matchColor,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(0);
                    setState(() {
                      selection[0] = 1;
                      selection[1] = 0;
                      selection[2] = 0;
                      onMatchClicked();
                    });
                  },
                ),
              ],
            ),
            Stack(
              key: widget.discoverIconKey,
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: duration,
                  height: circleDiscoverDiameter,
                  width: circleDiscoverDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.whatshot_rounded,
                    color: discoverColor,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(1);
                    setState(() {
                      selection[0] = 0;
                      selection[1] = 1;
                      selection[2] = 0;
                      onDiscoverClicked();
                    });
                  },
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: duration,
                  height: circleProfileDiameter,
                  width: circleProfileDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: profileColor,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(2);
                    setState(() {
                      selection[0] = 0;
                      selection[1] = 0;
                      selection[2] = 1;
                      onProfileClicked();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
