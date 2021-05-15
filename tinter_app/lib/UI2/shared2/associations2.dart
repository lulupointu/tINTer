import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

main() => runApp(MaterialApp(
      home: AssociationsTab2(),
    ));

class AssociationsTab2 extends StatefulWidget {
  static final Map<String, double> fractions = {
    'topSeparator': 0.08,
    'sheetSeparator': 0.1,
    'likedAssociations': 0.25,
    'horizontalMargin': 0.05,
    'titles': 0.05,
    'titlesSeparator': 0.01,
    'headerSpacing': 0.05,
  };
  final duration = Duration(milliseconds: 300);
  final Curve curve = Curves.easeIn;

  @override
  _AssociationsTab2State createState() => _AssociationsTab2State();
}

class _AssociationsTab2State extends State<AssociationsTab2> {
  int _keyboardVisibilitySubscriberId;
  bool isSearching = false;
  String searchString = "";
  PanelController _panelController;

  @protected
  void initState() {
    super.initState();
    _panelController = PanelController();
    KeyboardVisibilityController().onChange.listen(
      (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
          if (searchString == "") {
            clearSearch();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Associations',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            LikedAssociationsWidget2()
          ],
        ),
      ),
    );
  }

  void onSearch(String searchValue) {
    if (!_panelController.isPanelOpen) {
      _panelController.open();
    }
    setState(() {
      isSearching = true;
      searchString = searchValue;
    });
  }

  void clearSearch() {
    setState(() {
      isSearching = false;
      searchString = "";
    });
  }
}

class LikedAssociationsWidget2 extends StatelessWidget {
  const LikedAssociationsWidget2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mes associations',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Container(
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Nom de l'asso",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          Colors.black.withOpacity(0.6),
                                      width: 3,
                                    )),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Theme.of(context).indicatorColor,
                                )
                              ],
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    width: 144,
                    height: 144,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius:
                          BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
