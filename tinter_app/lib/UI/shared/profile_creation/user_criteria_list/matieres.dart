import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matieres/matieres_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';

main() => runApp(MaterialApp(
      home: MatieresTab(),
    ));

class MatieresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatieresBloc, MatieresState>(
        builder: (BuildContext context, MatieresState matieresState) {
      if (!(matieresState is MatieresLoadSuccessfulState)) {
        if (matieresState is MatieresInitialState) {
          BlocProvider.of<MatieresBloc>(context).add(MatieresLoadEvent());
        }
        return Center(child: CircularProgressIndicator());
      }
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
            'Mes matières préférées',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 30.0,
                  runSpacing: 30.0,
                  children: [
                    for (String matiere in (matieresState as MatieresLoadSuccessfulState).matieres) matiereChip(matiere)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget matiereChip(String matiere) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState userState) {
        if (!(userState is UserLoadSuccessState)) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        bool isLiked = (userState as UserLoadSuccessState).user.matieresPreferees.contains(matiere);
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (isLiked) {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.matieresPreferees.remove(
                      matiere)),
                ),
              );
            } else {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.matieresPreferees.add(
                      matiere)),
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0.2,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                  color:
                      (isLiked ? Colors.white : Theme.of(context).primaryColor),
                  width: 3.0,
                  style: BorderStyle.solid),
              color: isLiked ? Theme.of(context).primaryColor : Colors.white,
            ),
            child: Text(
              matiere,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black, fontSize: 13.0),
            ),
          ),
        );
      },
    );
  }
}
