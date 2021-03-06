import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';

class AssociatifToScolaireButton extends StatelessWidget {
  const AssociatifToScolaireButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: tinterTheme.colors.primaryAccent,
        ),
        height: 25,
        child: Stack(
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
                        tinterTheme.theme = MyTheme.dark;
                        // if (tinterTheme.theme == MyTheme.light)
                        //   Provider.of<TinterTheme>(context, listen: false).changeTheme();
                      },
                      child: Center(
                        child: TweenAnimationBuilder(
                            tween: ColorTween(
                                begin: tinterTheme.colors.defaultTextColor,
                                end: tinterTheme.colors.defaultTextColor),
                            duration: Duration(milliseconds: 200),
                            builder: (context, animatedColor, child) {
                              return Text(
                                'associatif',
                                style: TextStyle(color: animatedColor, fontSize: 16),
                              );
                            }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        tinterTheme.theme = MyTheme.light;
                        // if (tinterTheme.theme == MyTheme.dark)
                        //   Provider.of<TinterTheme>(context, listen: false).changeTheme();
                      },
                      child: Center(
                        child: Text(
                          'scolaire',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AssociatifToScolaireButtonOverlay extends StatelessWidget {
  final GlobalKey associatifToScolaireButtonKey;
  final VoidCallback removeSelf;

  AssociatifToScolaireButtonOverlay({@required this.associatifToScolaireButtonKey, @required this.removeSelf});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = associatifToScolaireButtonKey.currentContext.findRenderObject();
    var buttonSize = renderBox.size;
    var buttonOffset = renderBox.localToGlobal(Offset.zero);

    return GestureDetector(
      onTapUp: (details) {
        if (details.globalPosition.dx < buttonOffset.dx + buttonSize.width && details.globalPosition.dx > buttonOffset.dx + buttonSize.width/2 &&
            details.globalPosition.dy > buttonOffset.dy && details.globalPosition.dy < buttonOffset.dy + buttonSize.height) {
          Provider.of<TinterTheme>(context, listen: false).theme = MyTheme.light;
          // Provider.of<TinterTheme>(context, listen: false).changeTheme();
          removeSelf();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: ClipPath(
          clipper: InvertedClipper(
            associatifToScolaireButtonKey: associatifToScolaireButtonKey,
          ),
          child: Container(
            color: Colors.black54,
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  children: [
                    SizedBox(
                      height: buttonOffset.dy + buttonSize.height + 10,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Fonctionnalité exclusive pour les premières années TSP!',
                              style: tinterTheme.textStyle.headline2.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Clique sur \'scolaire\' pour passer l'application en mode scolaire. "
                              "Cela te permettra de trouver un binome de classe.",
                              style:
                                  tinterTheme.textStyle.dialogContent.copyWith(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  final GlobalKey associatifToScolaireButtonKey;

  InvertedClipper({@required this.associatifToScolaireButtonKey});

  @override
  Path getClip(Size size) {
    RenderBox renderBox = associatifToScolaireButtonKey.currentContext.findRenderObject();
    var buttonSize = renderBox.size;
    var buttonOffset = renderBox.localToGlobal(Offset.zero);

    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromLTRBAndCorners(
        buttonOffset.dx - 5,
        buttonOffset.dy - 5,
        buttonOffset.dx + buttonSize.width + 5,
        buttonOffset.dy + buttonSize.height + 5,
        topRight: Radius.circular(20.0),
        topLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
        bottomLeft: Radius.circular(20.0),
      ))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
