import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/associatif/user_profile/gout_musicaux.dart';
import 'package:tinterapp/UI/associatif/user_profile/user_associatif_profile.dart';
import 'package:tinterapp/UI/scolaire/user_profile/matieres.dart';
import 'package:tinterapp/UI/scolaire/user_profile/user_scolaire_profile.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

class CreateProfileScolaire extends StatelessWidget {
  final Widget separator;

  const CreateProfileScolaire({Key key, @required this.separator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InformationRectangle(
          padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          child: YearRectangle(),
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
              child: MaiselOuNonRectangle(),
            ),
          ),
          text: 'Clique pour dire si tu habite à la maisel ou non.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
              child: HoraireDeTravailRectangle(),
            ),
          ),
          text: 'Clique pour dire à quel moment de la journée tu aimes travailler.',
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: AssociationsRectangle(),
          ),
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: GroupeOuSeulRectangle(),
          ),
          text: 'Clique pour dire si tu aime travailler en groupe.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: EnLigneOuPresentielRectangle(),
          ),
          text:
              "Clique pour dire si tu préfére travailler en ligne ou à l\'école.",
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
              child: MatieresRectangle(),
            ),
          ),
          text: 'Clique pour selectionner tes matières préférées.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MatieresTab()),
            );
          },
        ),
      ],
    );
  }
}

class YearRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Quelle année est-tu?',
                style: TinterTextStyle.headline2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              width: double.infinity,
              child: Container(
                height: 60,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (BuildContext context, UserState userState) {
                    if (!(userState is NewUserState)) {
                      return CircularProgressIndicator();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as NewUserState)
                                        .user
                                        .rebuild((b) => b..year = TSPYear.TSP1A))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.year != TSPYear.TSP1A ? 0.5 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                  ),
                                  color: TinterColors.primaryAccent,
                                ),
                                width: 50,
                                child: Center(
                                  child: AutoSizeText('1A'),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as NewUserState)
                                        .user
                                        .rebuild((b) => b..year = TSPYear.TSP2A))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.year != TSPYear.TSP2A ? 0.5 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                color: TinterColors.primaryAccent,
                                width: 50,
                                child: Center(
                                  child: AutoSizeText('2A'),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as NewUserState)
                                        .user
                                        .rebuild((b) => b..year = TSPYear.TSP3A))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.year != TSPYear.TSP3A ? 0.5 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  color: TinterColors.primaryAccent,
                                ),
                                width: 50,
                                child: Center(
                                  child: AutoSizeText('3A'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
