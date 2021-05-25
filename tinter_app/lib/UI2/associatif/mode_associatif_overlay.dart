import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModeAssociatifOverlay extends StatelessWidget {
  static final double height = 35;
  const ModeAssociatifOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 145,
      child: Center(
        child: Text(
          'mode associatif',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(
          color: Colors.white,
          width: 4.0,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(3, 3),
          ),
        ],
      ),
    );
  }
}
