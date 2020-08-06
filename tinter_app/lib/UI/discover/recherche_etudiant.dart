import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Logic/models/match.dart';

import '../shared_element/const.dart';

main() => runApp(MaterialApp(
      home: RechercheEtudiantTab(),
));

List<Match> allUsers = [
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Name2',
    'surname': 'Surname2',
    'score': 65,
    'state': 0,
    'associations': [
      Association(
        name: 'AssociationX',
        description: 'This is the X association',
      ),
      Association(
        name: 'AssociationY',
        description: 'This is the Y association',
      ),
    ],
    'attiranceVieAsso': 0.21,
    'feteOuCours': 0.94,
    'aideOuSortir': 0.43,
    'organisationEvenements': 0.45,
    'goutsMusicaux': ['Pop', 'Rock', 'ok']
  }),
  Match.fromJson({
    'name': 'Name3',
    'surname': 'Surname3',
    'score': 23,
    'state': 0,
    'associations': [
      Association(
        name: 'AssociationZ',
        description: 'This is the Z association',
      ),
      Association(
        name: 'AssociationZZ',
        description: 'This is the ZZ association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock', 'Mock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
  Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
    'associations': [
      Association(
        name: 'Association1',
        description: 'This is the first association',
      ),
      Association(
        name: 'Association2',
        description: 'This is the second association',
      ),
      Association(
        name: 'Association3',
        description: 'This is the third association',
      ),
    ],
    'attiranceVieAsso': 0.56,
    'feteOuCours': 0.24,
    'aideOuSortir': 0.41,
    'organisationEvenements': 0.12,
    'goutsMusicaux': ['Pop', 'Rock']
  }),
];

class RechercheEtudiantTab extends StatefulWidget {
  @override
  _RechercheEtudiantTabState createState() => _RechercheEtudiantTabState();
}

class _RechercheEtudiantTabState extends State<RechercheEtudiantTab> {
  final Map<String, double> fractions = {
    'top': 0.2,
    'separator': 0.05,
  };

  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  FocusNode searchBarFocusNode = FocusNode();

  @protected
  void initState() {
    super.initState();

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          searchBarFocusNode.unfocus();
        }
      },
    );
  }

  @override
  void dispose() {
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: TinterColors.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: constraints.maxHeight * fractions['top'],
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/profile/topProfile.svg',
                        color: TinterColors.primaryLight,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AutoSizeText(
                            'Rechercher \n un.e étudiant.e',
                            style: TinterTextStyle.headline1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: TinterColors.hint,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: fractions['separator'] * constraints.maxHeight,
              ),
              Hero(
                tag: 'studentSearchBar',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      color: TinterColors.primaryAccent,
                    ),
                    child: TextField(
                      focusNode: searchBarFocusNode,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Icon(
                            Icons.search,
                            color: TinterColors.hint,
                          ),
                        ),
                      ),
                      autofocus: true,
                      maxLines: 1,
                      onChanged: (String text) {
                        print('CHANGED');
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: fractions['separator'] * constraints.maxHeight,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    // TODO: Change this to search
                    children: [
                      for (Match match in allUsers)
                        userResume(match)
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget userResume(Match match) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: TinterColors.primary,
      ),
      margin: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow,
          ),
          height: 50,
          width: 50,
        ),
        trailing: FlatButton(
          onPressed: () {},
          child: Text('Voir profil'),
          color: TinterColors.primaryAccent,
        ),
        title: Text(
          match.name + ' ' + match.surname,
          style: TinterTextStyle.headline2,
        ),
      ),
    );
  }

  Widget informationRectangle({
    @required Widget child,
    double width,
    double height,
    EdgeInsets padding,
    Color color,
    EdgeInsets margin,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: color ?? TinterColors.primaryAccent,
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
