import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/user_profile/profile_bloc.dart';
import 'package:tinterapp/Logic/repository/discover_repository.dart';
import 'package:tinterapp/Logic/repository/matched_repository.dart';
import 'package:tinterapp/Logic/repository/profile_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/tinter_bottom_navigation_bar.dart';
import 'package:tinterapp/UI/matches.dart';
import 'package:tinterapp/UI/profile.dart';
import 'package:http/http.dart' as http;

import 'UI/discover.dart';
import 'UI/const.dart';

main() {
  final http.Client httpClient = http.Client();
  TinterApiClient tinterApiClient = TinterApiClient(
    httpClient: httpClient,
  );

  final ProfileRepository profileRepository =
      ProfileRepository(tinterApiClient: tinterApiClient);

  final MatchedRepository matchedRepository =
      MatchedRepository(tinterApiClient: tinterApiClient);

  final DiscoverRepository discoverRepository =
      DiscoverRepository(tinterApiClient: tinterApiClient);

  runApp(
    MaterialApp(
      home: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileBloc>(
              create: (BuildContext context) =>
                  ProfileBloc(profileRepository: profileRepository),
            ),
            BlocProvider<MatchedMatchesBloc>(
              create: (BuildContext context) =>
                  MatchedMatchesBloc(matchedRepository: matchedRepository),
            ),
            BlocProvider(
              create: (BuildContext context) =>
                  DiscoverMatchesBloc(discoverRepository: discoverRepository),
            ),
          ],
          child: Tinter(),
        ),
      ),
    ),
  );
}

class Tinter extends StatefulWidget {
  final List<Widget> tabs = [MatchsTab(), DiscoverTab(), ProfileTab()];

  @override
  _TinterState createState() => _TinterState();
}

class _TinterState extends State<Tinter> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TinterColors.background,
      body: widget.tabs[_selectedTab],
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }
}
