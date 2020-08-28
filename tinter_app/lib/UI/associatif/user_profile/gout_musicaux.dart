import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';

import '../../shared/shared_element/const.dart';

main() => runApp(MaterialApp(
      home: GoutsMusicauxTab(),
    ));

List<String> goutsMusicaux = [
  'Rock',
  'Pop',
  'Electro',
  'Hip-hop',
  'Rap',
  'Trap',
  'Variété',
  'Classique',
  'Opéra',
  'R&B',
  'Soul',
  'Blues',
  'Metal',
  'Jazz',
  'Punk',
  'Disco',
  'Funk',
  'Country',
  'Reggae',
  'Affro',
  'Gospel',
  'Hard-Rock',
  'K-Pop',
  'Techno'
];

class GoutsMusicauxTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: tinterTheme.colors.background,
            body: child,
          ),
        );
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.2,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return SvgPicture.asset(
                              'assets/profile/topProfile.svg',
                              color: tinterTheme.colors.primary,
                              fit: BoxFit.fill,
                            );
                          }
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return Text(
                              'Goûts Musicaux',
                              maxLines: 1,
                              style: tinterTheme.textStyle.headline1,
                            );
                          }
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return Icon(
                              Icons.arrow_back,
                              size: 24,
                              color: tinterTheme.colors.primaryAccent,
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: SingleChildScrollView(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20.0,
                        runSpacing: 20.0,
                        children: [
                          for (String goutMusical in goutsMusicaux)
                            goutMusicalChip(goutMusical)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget goutMusicalChip(String goutMusical) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState userState) {
        if (!(userState is UserLoadSuccessState)) {
          return CircularProgressIndicator();
        }
        bool isLiked =
            (userState as UserLoadSuccessState).user.goutsMusicaux.contains(goutMusical);
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (isLiked) {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.goutsMusicaux.remove(goutMusical)),
                ),
              );
            } else {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.goutsMusicaux.add(goutMusical)),
                ),
              );
            }
          },
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                color: isLiked
                    ? tinterTheme.colors.primaryAccent
                    : Color.fromARGB(255, 70, 70, 70),
              ),
              child: Text(
                goutMusical,
                style: isLiked
                    ? tinterTheme.textStyle.chipLiked
                    : tinterTheme.textStyle.chipNotLiked,
              ),
            );
          }),
        );
      },
    );
  }
}
