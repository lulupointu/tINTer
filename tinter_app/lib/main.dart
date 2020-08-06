import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/user/user_bloc.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/discover_repository.dart';
import 'package:tinterapp/Logic/repository/matched_repository.dart';
import 'package:tinterapp/Logic/repository/user_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/login.dart';
import 'package:tinterapp/UI/my_bubble_navigation_bar.dart';
import 'package:tinterapp/UI/splash_screen.dart';
import 'package:tinterapp/UI/tinter_bottom_navigation_bar.dart';
import 'package:tinterapp/UI/matches.dart';
import 'package:tinterapp/UI/user_profile.dart';
import 'package:http/http.dart' as http;

import 'UI/discover.dart';
import 'UI/const.dart';

main() {
  Bloc.observer = AllBlocObserver();

  final http.Client httpClient = http.Client();
  TinterApiClient tinterApiClient = TinterApiClient(
    httpClient: httpClient,
  );

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(tinterApiClient: tinterApiClient);

  final UserRepository userRepository = UserRepository(tinterApiClient: tinterApiClient);

  final MatchedRepository matchedRepository =
      MatchedRepository(tinterApiClient: tinterApiClient);

  final DiscoverRepository discoverRepository =
      DiscoverRepository(tinterApiClient: tinterApiClient);

  runApp(
    KeyboardVisibilityProvider(
      child: KeyboardDismissOnTap(
        child: BlocProvider(
          create: (BuildContext context) =>
              AuthenticationBloc(authenticationRepository: authenticationRepository),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                create: (BuildContext context) => UserBloc(userRepository: userRepository),
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
            child: MaterialApp(
              home: SafeArea(
                child: Tinter(),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class Tinter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        if (state is AuthenticationSuccessfulState) {
          return TinterHome();
        } else if (state is AuthenticationInitialState) {
          return SplashScreen();
        } else {
          return TinterAuthenticationTab();
        }
      },
    );
  }
}

class TinterHome extends StatefulWidget {
  final List<Widget> tabs = [MatchsTab(), DiscoverTab(), UserTab()];

  @override
  _TinterHomeState createState() => _TinterHomeState();
}

class _TinterHomeState extends State<TinterHome> {
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
    _selectedTab = index;
    setState(() {});
  }
}

class AllBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('${cubit.runtimeType} $error $stackTrace');
    super.onError(cubit, error, stackTrace);
  }
}
