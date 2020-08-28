import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TinterTheme(),
      child: Scaffold(
        backgroundColor: Color(0xFFFA3C3C),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<TinterTheme>(context, listen: false).changeTheme(),
        ),
        body: Consumer<TinterTheme>(
            builder: (context, tinterTheme, child) {
              return Center(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: tinterTheme.colors.primaryAccent,
              ),
              height: 24,
              width: 250,
              child:  Stack(
                    children: [
                      AnimatedAlign(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        alignment: Alignment(tinterTheme.theme == MyTheme.dark ? -1 : 1, 0),
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: tinterTheme.colors.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (tinterTheme.theme == MyTheme.light) Provider.of<TinterTheme>(context, listen: false).changeTheme();
                                },
                                child: Center(
                                  child: TweenAnimationBuilder(
                                    tween: ColorTween(begin: tinterTheme.colors.defaultTextColor, end: tinterTheme.colors.defaultTextColor),
                                    duration: Duration(milliseconds: 200),
                                    builder: (context, animatedColor, child) {
                                      return Text(
                                        'associatif',
                                        style: TextStyle(color: animatedColor),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (tinterTheme.theme == MyTheme.dark) Provider.of<TinterTheme>(context, listen: false).changeTheme();
                                },
                                child: Center(
                                  child: Text(
                                    'scolaire',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ));
          }
        ),
      ),
    );
  }
}
