import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/Logic/blocs/user_profile/profile_bloc.dart';

import 'const.dart';

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
                            'assets/Profile/topProfile.svg',
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget goutMusicalChip(String goutMusical) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState profileState) {
        if (!(profileState is ProfileLoadSuccessState)) {
          return CircularProgressIndicator();
        }
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if ((profileState as ProfileLoadSuccessState).profile.goutsMusicaux.contains(goutMusical)) {
              BlocProvider.of<ProfileBloc>(context).add(
                GoutMusicauxEvent(
                  status: GoutMusicauxEventStatus.remove,
                  goutMusical: goutMusical,
                ),
              );
            } else {
              BlocProvider.of<ProfileBloc>(context).add(
                GoutMusicauxEvent(
                  status: GoutMusicauxEventStatus.add,
                  goutMusical: goutMusical,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
              color: (profileState as ProfileLoadSuccessState).profile.goutsMusicaux.contains(goutMusical)
                  ? TinterColors.primaryAccent
                  : TinterColors.grey,
            ),
            child: Text(goutMusical),
          ),
        );
      },
    );
  }
}
