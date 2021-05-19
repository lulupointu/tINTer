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
                Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selection[0] == 0
                        ? Colors.transparent
                        : Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.favorite_outline_rounded,
                    color: selection[0] == 0
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(0);
                    setState(() {
                      selection[0] = 1;
                      selection[1] = 0;
                      selection[2] = 0;
                    });
                  },
                ),
              ],
            ),
            Stack(
              key: widget.discoverIconKey,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selection[1] == 0
                        ? Colors.transparent
                        : Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.whatshot_rounded,
                    color: selection[1] == 0
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(1);
                    setState(() {
                      selection[0] = 0;
                      selection[1] = 1;
                      selection[2] = 0;
                    });
                  },
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selection[2] == 0
                        ? Colors.transparent
                        : Theme.of(context).primaryColor,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: selection[2] == 0
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    size: 28.0,
                  ),
                  onTap: () {
                    widget.onTap(2);
                    setState(() {
                      selection[0] = 0;
                      selection[1] = 0;
                      selection[2] = 1;
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
