import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/associative_to_scolaire2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/associative_criteria_list2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/scolaire_criteria_list2.dart';

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
    setState(() {
      isMatieresPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ScolaireNextButton(isMatieresPressed: isMatieresPressed,),
          ],
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Container(
              width: 275,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    HoveringUserPicture2(size: 95.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (BuildContext context, UserState userState) {
                          return Text(
                            ((userState is NewUserState))
                                ? userState.user.name +
                                    " " +
                                    userState.user.surname
                                : 'En chargement...',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Nouvel utilisateur',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScolaireNextButton extends StatelessWidget {
  const ScolaireNextButton({Key key, @required this.isMatieresPressed}) : super(key: key);

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
          onPressed: !isMatieresPressed ? null : () {
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
