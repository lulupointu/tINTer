import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif/user_associatif_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/associations/associations_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/repository/associatif/associations_repository.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/discover_matches_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/matched_matches_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/user_associatif_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/discover/discover.dart';
import 'package:tinterapp/UI/login/login.dart';
import 'package:tinterapp/UI/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared_element/const.dart';
import 'package:tinterapp/UI/splash_screen/splash_screen.dart';
import 'package:tinterapp/UI/shared_element/tinter_bottom_navigation_bar.dart';
import 'package:tinterapp/UI/matches/matches.dart';
import 'package:tinterapp/UI/user_profile/user_profile.dart';
import 'package:http/http.dart' as http;


final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

main() {
  Bloc.observer = AllBlocObserver();

  final http.Client httpClient = http.Client();
  TinterAPIClient tinterAPIClient = TinterAPIClient(
    httpClient: httpClient,
  );

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(tinterAPIClient: tinterAPIClient);

  final UserAssociatifRepository userRepository = UserAssociatifRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedMatchesRepository matchedMatchesRepository = MatchedMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final DiscoverMatchesRepository discoverMatchesRepository = DiscoverMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final AssociationsRepository associationsRepository = AssociationsRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  runApp(
    KeyboardVisibilityProvider(
      child: KeyboardDismissOnTap(
        child: BlocProvider(
          create: (BuildContext context) =>
              AuthenticationBloc(authenticationRepository: authenticationRepository),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserAssociatifBloc>(
                create: (BuildContext context) => UserAssociatifBloc(
                  userRepository: userRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<MatchedMatchesBloc>(
                create: (BuildContext context) => MatchedMatchesBloc(
                  matchedMatchesRepository: matchedMatchesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider(
                create: (BuildContext context) => DiscoverMatchesBloc(
                  discoverMatchesRepository: discoverMatchesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider(
                create: (BuildContext context) => AssociationsBloc(
                  associationsRepository: associationsRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider(
                create: (BuildContext context) => UserAssociatifSearchBloc(
                  userRepository: userRepository,
                  matchedMatchesRepository: matchedMatchesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
            ],
            child: MaterialApp(
              home: SafeArea(
                child: Tinter(),
              ),
              navigatorObservers: [routeObserver],
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
    // First check the authentication state
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState authenticationState) {
        if (authenticationState is AuthenticationInitialState ||
            authenticationState is AuthenticationInitializingState) {
          if (authenticationState is AuthenticationInitialState) {
            // Try to authenticate with a token, if fail present the login screen
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationLogWithTokenRequestSentEvent());
          }
          return SplashScreen();
        } else if (!(authenticationState is AuthenticationSuccessfulState)) {
          return TinterAuthenticationTab();
        }

        // next check on the user state
        return BlocBuilder<UserAssociatifBloc, UserAssociatifState>(
          builder: (BuildContext context, UserAssociatifState userState) {
            if (userState is UserInitialState) {
              BlocProvider.of<UserAssociatifBloc>(context).add(UserInitEvent());
              return SplashScreen();
            } else if (userState is UserInitializingState) {
              return SplashScreen();
            } else if (userState is NewUserSavingState) {
              return SplashScreen();
            } else if (userState is NewUserAssociatifState) {
              return UserCreationTab();
            } else if (userState is KnownUserAssociatifState) {
              return TinterHome();
            }
            return Center(child: Text('Error, Unknown state: ${userState.runtimeType}'));
          },
        );
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
  int _selectedTab = 2;

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
