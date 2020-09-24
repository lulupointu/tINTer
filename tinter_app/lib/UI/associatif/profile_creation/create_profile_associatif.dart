import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/associatif/user_profile/gout_musicaux.dart';
import 'package:tinterapp/UI/associatif/user_profile/user_associatif_profile.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

class CreateProfileAssociatif extends StatelessWidget {
  final Widget separator;

  const CreateProfileAssociatif({Key key, @required this.separator,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InformationRectangle(
          padding: EdgeInsets.only(top: 15.0, left: 20.0),
          child: PrimoEntrantRectangle(),
        ),
        separator,
        InformationRectangle(
          padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          child: YearRectangle(),
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: AssociationsRectangle(),
            ),
          ),
          text: 'Clique pour choisir tes associations.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssociationsTab()),
            );
          },
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: AttiranceVieAssoRectangle(),
          ),
          text: 'Clique pour dire à quel point te plait la vie associative.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: FeteOuCoursRectangle(),
          ),
          text: 'Clique pour dire si tu es plutôt fête ou cours.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: AideOuSortirRectangle(),
          ),
          text:
          "Clique pour dire si tu préféres un parrain qui t'aide scolairement ou avec qui sortir.",
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: OrganisationEvenementsRectangle(),
          ),
          text: 'Clique pour dire si tu aimes organiser des événements.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
              child: GoutsMusicauxRectangle(),
            ),
          ),
          text: 'Clique pour choisir tes goûts musicaux.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
            );
          },
        ),
      ],
    );
  }
}


class PrimoEntrantRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return Text(
                    'Es-tu primo-entrant?',
                    style: tinterTheme.textStyle.headline2,
                  );
                }
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
                      return Center(child: CircularProgressIndicator(),);
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
                                        .rebuild((b) => b..primoEntrant = true))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.primoEntrant ? 1 : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 50,
                                    child: Center(
                                      child: AutoSizeText('Oui'),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as NewUserState)
                                        .user
                                        .rebuild((b) => b..primoEntrant = false))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.primoEntrant ? 0.5 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 50,
                                    child: Center(
                                      child: AutoSizeText('Non'),
                                    ),
                                  );
                                }
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

class YearRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return Text(
                      'Quelle année es-tu?',
                      style: tinterTheme.textStyle.headline2,
                    );
                  }
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
                      return Center(child: CircularProgressIndicator(),);
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
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                        ),
                                        color: tinterTheme.colors.primaryAccent,
                                      ),
                                      width: 50,
                                      child: Center(
                                        child: AutoSizeText('1A'),
                                      ),
                                    );
                                  }
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
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                      color: tinterTheme.colors.primaryAccent,
                                      width: 50,
                                      child: Center(
                                        child: AutoSizeText('2A'),
                                      ),
                                    );
                                  }
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
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        ),
                                        color: tinterTheme.colors.primaryAccent,
                                      ),
                                      width: 50,
                                      child: Center(
                                        child: AutoSizeText('3A'),
                                      ),
                                    );
                                  }
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


