import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: TinterColors.background,
        body: LayoutBuilder(
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
                          child: SvgPicture.asset(
                            'assets/profile/topProfile.svg',
                            color: TinterColors.primaryLight,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            'Goûts Musicaux',
                            maxLines: 1,
                            style: TinterTextStyle.headline1,
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
                            for (String goutMusical in goutsMusicaux) goutMusicalChip(goutMusical)
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
      ),
    );
  }

  Widget goutMusicalChip(String goutMusical) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState userState) {
        if (!(userState is UserLoadSuccessState)) {
          return CircularProgressIndicator();
        }
        bool isLiked = (userState as UserLoadSuccessState).user.goutsMusicaux.contains(goutMusical);
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (isLiked) {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.goutsMusicaux.remove(
                      goutMusical)),
                ),
              );
            } else {
              BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.goutsMusicaux.add(
                      goutMusical)),
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
              color: isLiked
                  ? TinterColors.primaryAccent
                  : Color.fromARGB(255, 70, 70, 70),
            ),
            child: Text(goutMusical, style: isLiked ? TinterTextStyle.goutMusicauxLiked : TinterTextStyle.goutMusicauxNotLiked,),
          ),
        );
      },
    );
  }
}
