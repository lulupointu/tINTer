import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/UI/const.dart';

main() {
  runApp(MaterialApp(
    home: Material(
      color: Colors.blue,
      child: Center(
        child: BubbleNavigationBar(
          items: [
            BubbleNavigationItem(
              unselectedIcon: SvgPicture.asset(
                'assets/Icons/match.svg',
                width: 24,
                color: TinterColors.secondaryAccent,
              ),
              selectedIcon: SvgPicture.asset(
                'assets/Icons/match.svg',
                width: 24,
                color: TinterColors.white,
              ),
              title: AutoSizeText(
                "Matches",
                textAlign: TextAlign.center,
                maxFontSize: 18,
                style: TinterTextStyle.BottomNavigationBarTextStyle,
                maxLines: 1,
              ),
            ),
            BubbleNavigationItem(
              unselectedIcon: SvgPicture.asset(
                'assets/Icons/discover.svg',
                width: 20,
                color: TinterColors.secondaryAccent,
              ),
              selectedIcon: SvgPicture.asset(
                'assets/Icons/discover.svg',
                width: 20,
                color: TinterColors.white,
              ),
              title: AutoSizeText(
                "Discover",
                textAlign: TextAlign.center,
                maxFontSize: 18,
                style: TinterTextStyle.BottomNavigationBarTextStyle,
                maxLines: 1,
              ),
            ),
            BubbleNavigationItem(
              unselectedIcon: SvgPicture.asset(
                'assets/Icons/profile.svg',
                width: 21,
                color: TinterColors.secondaryAccent,
              ),
              selectedIcon: SvgPicture.asset(
                'assets/Icons/profile.svg',
                width: 21,
                color: TinterColors.white,
              ),
              title: AutoSizeText(
                "Profile",
                textAlign: TextAlign.center,
                maxFontSize: 18,
                style: TinterTextStyle.BottomNavigationBarTextStyle,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

class BubbleNavigationBar extends StatefulWidget {
  final List<BubbleNavigationItem> items;
  final double height;
  final Function(int) onTap;

  final List<double> selectedIconWidths = [];
  final List<double> unselectedIconWidths = [];
  final List<double> titleWidths = [];

  BubbleNavigationBar({@required this.items, this.height: 100, this.onTap});

  @override
  _BubbleNavigationBarState createState() => _BubbleNavigationBarState(selectedIndex: 0);
}

class _BubbleNavigationBarState extends State<BubbleNavigationBar> {
  bool itemWidthGathered = false;
  Duration duration = Duration(milliseconds: 300);

  int selectedIndex;
  double appWidth;

  _BubbleNavigationBarState({@required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    if (!itemWidthGathered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateItemWidths(context);
        itemWidthGathered = true;
        setState(() {});
      });
    } else {
      for (int index = 0; index < widget.items.length; index++) {
        print('item: ' + widget.items[index].toString());
        print('selectedIconWidth: ' + widget.selectedIconWidths[index].toString());
        print('unselectedIconWidth: ' + widget.unselectedIconWidths[index].toString());
        print('titleWidth: ' + widget.titleWidths[index].toString());
      }
    }

    return Container(
      height: widget.height,
      child: (!itemWidthGathered)
          ? _widgetToCalculate()
          : Stack(
              children: [
                _backWidget(),
                ..._frontWidgets(),
                ...frontInkWells(),
              ],
            ),
    );
  }

  void _calculateItemWidths(BuildContext context) {
    // Calculate the width
    for (BubbleNavigationItem item in widget.items) {
      widget.titleWidths.add(item.titleKey.currentContext.size.width);
      widget.selectedIconWidths.add(item.selectedIconKey.currentContext.size.width);
      widget.unselectedIconWidths.add(item.unselectedIconKey.currentContext.size.width);
    }

    // insert index to the items
    for (int index = 0; index < widget.items.length; index++) {
      widget.items[index].index = index;
    }
  }

  // This doesn't even paint anything but allows to
  // calculate the width of all widgets.
  // This also gets the app width.
  Widget _widgetToCalculate() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      appWidth = constraints.maxWidth;
      return Offstage(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (BubbleNavigationItem item in widget.items) ...[
              item.selectedIconContainer,
              item.unselectedIconContainer,
              item.titleWidgetContainer,
            ]
          ],
        ),
      );
    });
  }

  Widget _backWidget() {
    return AnimatedPositioned(
      left: _getBackContainerPosition(),
      width: _getSelectedSpaceWidth(),
      duration: duration,
      child: Container(
        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          color: Colors.red,
        ),
        height: 50,
      ),
    );
  }

  double _getBackContainerPosition() {
    return selectedIndex * _getUnselectedItemWidth();
  }

  double _getSelectedItemWidth() {
    return widget.selectedIconWidths[selectedIndex] + widget.titleWidths[selectedIndex];
  }

  double _getSelectedSpaceWidth() {
    return max(_getSelectedItemWidth(), (appWidth) / (widget.items.length));
  }

  double _getUnselectedItemWidth() {
    return (appWidth - _getSelectedSpaceWidth()) / (widget.items.length - 1);
  }

  BubbleNavigationItem _getSelectedItem() {
    return widget.items[selectedIndex];
  }

  double _getUnselectedItemPos(int index) {
    return _getUnselectedItemWidth() * index +
        ((index > selectedIndex) ? _getSelectedSpaceWidth() - _getUnselectedItemWidth() : 0);
  }

  double _getUnselectedIconPos(int index) {
    return _getUnselectedItemPos(index) +
        _getUnselectedItemWidth() / 2 -
        widget.unselectedIconWidths[index] / 2;
  }

  double _getSelectedIconPos() {
    return _getBackContainerPosition();
  }

  double _getSelectedTitlePos() {
    return _getSelectedIconPos() + widget.selectedIconWidths[selectedIndex];
  }

  List<Widget> _frontWidgets() {
    return [
      ..._frontIcons(),
      _selectedTitle(),
    ];
  }

  List<Widget> _frontIcons() {
    return [
      for (int index = 0; index < widget.items.length; index++)
        (index == selectedIndex)
            ? AnimatedPositioned(
                left: _getSelectedIconPos(),
                duration: duration,
                child: Container(
                  width: widget.selectedIconWidths[index],
                  child: widget.items[index].title,
                  color: Colors.green,
                ),
              )
            : AnimatedPositioned(
                duration: duration,
                left: _getUnselectedIconPos(index),
                child: Container(
                  width: widget.unselectedIconWidths[index],
                  child: widget.items[index].title,
                  color: Colors.green,
                ),
              ),
    ];
  }

  Widget _selectedTitle() {
    return Positioned(
      left: _getSelectedTitlePos(),
      child: _getSelectedItem().title,
    );
  }

  List<Widget> frontInkWells() {
    final selectedItem = _getSelectedItem();

    return [
      for (BubbleNavigationItem item in widget.items)
        (item == selectedItem)
            ? Container()
            : AnimatedPositioned(
                duration: duration,
                left: _getUnselectedItemPos(item.index),
                child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => onTap(item.index),
                    child: SizedBox(
                      width: _getUnselectedItemWidth(),
                      height: widget.height,
                    )),
              ),
    ];
  }

  void onTap(int index) {
    selectedIndex = index;
    if (widget.onTap != null) {
      widget.onTap(index);
    }
    setState(() {});
  }
}

class BubbleNavigationItem {
  final Widget title;
  final Widget selectedIcon;
  final Widget unselectedIcon;
  Widget titleWidgetContainer;
  Widget selectedIconContainer;
  Widget unselectedIconContainer;
  final double marginRightIcon;

  int index;

  GlobalKey selectedIconKey, unselectedIconKey, titleKey;

  BubbleNavigationItem({
    @required this.title,
    @required this.selectedIcon,
    unselectedIcon,
    this.marginRightIcon: 6,
  })  : assert(title != null),
        assert(selectedIcon != null),
        this.unselectedIcon = unselectedIcon ?? selectedIcon,
        selectedIconKey = GlobalKey(),
        unselectedIconKey = GlobalKey(),
        titleKey = GlobalKey() {
    titleWidgetContainer = Container(
      key: titleKey,
      child: title,
    );
    selectedIconContainer = Container(
      key: selectedIconKey,
      child: selectedIcon,
    );
    unselectedIconContainer = Container(
      key: unselectedIconKey,
      child: unselectedIcon,
    );
  }
}
