import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;
  final List<CustomBottomNavigationBarItem> items;

  CustomBottomNavigationBar({
    Key key,
    @required this.onTap,
    @required this.selectedIndex,
    @required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            for (var i = 0; i < items.length; i++)
              GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      5.0,
                    ),
                    child: CustomBottomNavigationBarItemWidget(
                      icon: items[i].icon,
                      key: items[i].key,
                      isSelected: i == selectedIndex,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBarItem {
  final IconData icon;
  final Key key;

  CustomBottomNavigationBarItem({@required this.icon, this.key});
}

class CustomBottomNavigationBarItemWidget extends StatelessWidget {
  final Duration animationDuration = Duration(milliseconds: 300);
  final double size = 44.0;

  final Color selectedIconColor = Colors.white;

  final IconData icon;
  final bool isSelected;

  CustomBottomNavigationBarItemWidget({
    @required this.icon,
    @required this.isSelected,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: animationDuration,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            height: isSelected ? size : 0,
            width: isSelected ? size : 0,
          ),
          Center(
            child: TweenAnimationBuilder<Color>(
              duration: animationDuration,
              tween: ColorTween(
                begin: isSelected
                    ? selectedIconColor
                    : Theme.of(context).primaryColor,
                end: isSelected
                    ? selectedIconColor
                    : Theme.of(context).primaryColor,
              ),
              builder: (_, animation, __) {
                return Icon(
                  icon,
                  color: animation,
                  size: 28.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
