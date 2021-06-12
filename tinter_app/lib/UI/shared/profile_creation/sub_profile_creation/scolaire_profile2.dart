import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/shared/profile_creation/user_criteria_list2/scolaire_criteria_list2.dart';

import '../../const.dart';
import 'associative_profile2.dart';

class ScolaireProfile2 extends StatefulWidget {
  @override
  _ScolaireProfile2State createState() => _ScolaireProfile2State();
}

class _ScolaireProfile2State extends State<ScolaireProfile2> {
  Widget separator = SizedBox(
    height: 25,
  );

  bool isMatieresPressed = false;

  void onMatieresPressed() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isMatieresPressed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ScolaireCriteriaList2(
                    separator: SizedBox(
                      height: 20.0,
                    ),
                    onMatieresPressed: onMatieresPressed,
                    isMatieresPressed: isMatieresPressed,
                  ),
                ),
                separator,
                ScolaireNextButton(
                  isMatieresPressed: isMatieresPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                HoveringUserPicture2(
                  size: 100.0,
                  showModifyOption: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      return Text(
                        ((userState is NewUserState))
                            ? userState.user.name + " " + userState.user.surname
                            : 'En chargement...',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: Text(
                    'Nouveau compte',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ScolaireNextButton extends StatelessWidget {
  const ScolaireNextButton({Key key, @required this.isMatieresPressed})
      : super(key: key);

  final bool isMatieresPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState userState) {
      if (!(userState is UserLoadSuccessState)) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        height: 65,
        child: ElevatedButton(
          onPressed: !isMatieresPressed
              ? null
              : () {
                  Provider.of<TinterTheme>(context, listen: false).theme =
                      MyTheme.light;
                  BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
                },
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
          ),
          child: Center(
            child: Text(
              "Créer mon profil",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}
