import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/discover_binomes/discover_binomes_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binomes/binomes_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matieres/matieres_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/user_scolaire_search/user_scolaire_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/associations/associations_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/repository/scolaire/discover_binomes_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binomes_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/matieres_repository.dart';
import 'package:tinterapp/Logic/repository/shared/associations_repository.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/discover_matches_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/matched_matches_repository.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:http/http.dart' as http;
import 'package:tinterapp/UI/associatif/discover/discover.dart';
import 'package:tinterapp/UI/associatif/matches/matches.dart';
import 'package:tinterapp/UI/scolaire/binomes/binomes.dart';
import 'package:tinterapp/UI/scolaire/discover/discover.dart';
import 'package:tinterapp/UI/shared/login/login.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/tinter_bottom_navigation_bar.dart';
import 'package:tinterapp/UI/shared/splash_screen/splash_screen.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

main() {
  Bloc.observer = AllBlocObserver();

  final http.Client httpClient = http.Client();
  TinterAPIClient tinterAPIClient = TinterAPIClient(
    httpClient: httpClient,
  );

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(tinterAPIClient: tinterAPIClient);

  final UserRepository userRepository = UserRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedMatchesRepository matchedMatchesRepository = MatchedMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final DiscoverMatchesRepository discoverMatchesRepository = DiscoverMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedBinomesRepository matchedBinomesRepository = MatchedBinomesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final DiscoverBinomesRepository discoverBinomesRepository = DiscoverBinomesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final AssociationsRepository associationsRepository = AssociationsRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatieresRepository matieresRepository = MatieresRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  runApp(
    KeyboardVisibilityProvider(
      child: KeyboardDismissOnTap(
        child: BlocProvider(
          create: (BuildContext context) =>
              AuthenticationBloc(authenticationRepository: authenticationRepository),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                create: (BuildContext context) => UserBloc(
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
              BlocProvider<DiscoverMatchesBloc>(
                create: (BuildContext context) => DiscoverMatchesBloc(
                  discoverMatchesRepository: discoverMatchesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<MatchedBinomesBloc>(
                create: (BuildContext context) => MatchedBinomesBloc(
                  matchedBinomesRepository: matchedBinomesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<DiscoverBinomesBloc>(
                create: (BuildContext context) => DiscoverBinomesBloc(
                  discoverBinomesRepository: discoverBinomesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<UserAssociatifSearchBloc>(
                create: (BuildContext context) => UserAssociatifSearchBloc(
                  userRepository: userRepository,
                  matchedMatchesRepository: matchedMatchesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<UserScolaireSearchBloc>(
                create: (BuildContext context) => UserScolaireSearchBloc(
                  userRepository: userRepository,
                  matchedBinomesRepository: matchedBinomesRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<AssociationsBloc>(
                create: (BuildContext context) => AssociationsBloc(
                  associationsRepository: associationsRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
              BlocProvider<MatieresBloc>(
                create: (BuildContext context) => MatieresBloc(
                  matieresRepository: matieresRepository,
                  authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                ),
              ),
            ],
            child: ChangeNotifierProvider<TinterTheme>(
              create: (_) => TinterTheme(),
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
        return BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState userState) {
            if (userState is UserInitialState) {
              BlocProvider.of<UserBloc>(context).add(UserInitEvent());
              return SplashScreen();
            } else if (userState is UserInitializingState) {
              return SplashScreen();
            } else if (userState is NewUserSavingState) {
              return SplashScreen();
            } else if (userState is NewUserState) {
              return UserCreationTab();
            } else if (userState is KnownUserState) {
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
  final List<Widget> tabsAssociatif = [MatchsTab(), DiscoverAssociatifTab(), UserTab()];
  final List<Widget> tabsScolaire = [BinomesTab(), DiscoverScolaireTab(), UserTab()];

  @override
  _TinterHomeState createState() => _TinterHomeState();
}

class _TinterHomeState extends State<TinterHome> {
  int _selectedTab = 2;

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Scaffold(
          backgroundColor: tinterTheme.colors.background,
          body: child,
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: _onItemTapped,
          ),
        );
      },
      child:  Consumer<TinterTheme>(
          builder: (context, tinterTheme, child) {
            return tinterTheme.theme == MyTheme.dark ? widget.tabsAssociatif[_selectedTab] : widget.tabsScolaire[_selectedTab] ;
        }
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
