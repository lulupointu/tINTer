import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/binome_pair/binome_pair_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/binome_pair_search/binome_pair_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/discover_binome_pair_matches/discover_binome_pair_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/discover_binomes/discover_binomes_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binome_pair_matches/matched_pair_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binomes/binomes_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matieres/matieres_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/user_scolaire_search/user_scolaire_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/associations/associations_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/repository/scolaire/binome_pair_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/discover_binome_pair_matches_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/discover_binomes_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binome_pair_matches_repository.dart';
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
import 'package:tinterapp/UI/scolaire/discover_binome_pair/discover_binome_pair.dart';
import 'package:tinterapp/UI/shared/login/login.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/tinter_bottom_navigation_bar.dart';
import 'package:tinterapp/UI/shared/splash_screen/splash_screen.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

main() {
//  Bloc.observer = AllBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  final http.Client httpClient = http.Client();
  TinterAPIClient tinterAPIClient = TinterAPIClient(
    httpClient: httpClient,
  );

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(tinterAPIClient: tinterAPIClient);

  final UserRepository userRepository = UserRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final BinomePairRepository binomePairRepository = BinomePairRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedMatchesRepository matchedMatchesRepository = MatchedMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final DiscoverMatchesRepository discoverMatchesRepository = DiscoverMatchesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedBinomesRepository matchedBinomesRepository = MatchedBinomesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final DiscoverBinomesRepository discoverBinomesRepository = DiscoverBinomesRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatchedBinomePairMatchesRepository matchedBinomePairMatchesRepository =
      MatchedBinomePairMatchesRepository(
          tinterAPIClient: tinterAPIClient,
          authenticationRepository: authenticationRepository);

  final DiscoverBinomePairMatchesRepository discoverBinomePairMatchesRepository =
      DiscoverBinomePairMatchesRepository(
          tinterAPIClient: tinterAPIClient,
          authenticationRepository: authenticationRepository);

  final AssociationsRepository associationsRepository = AssociationsRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  final MatieresRepository matieresRepository = MatieresRepository(
      tinterAPIClient: tinterAPIClient, authenticationRepository: authenticationRepository);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
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
                BlocProvider<BinomePairBloc>(
                  create: (BuildContext context) => BinomePairBloc(
                    binomePairRepository: binomePairRepository,
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
                BlocProvider<MatchedBinomePairMatchesBloc>(
                  create: (BuildContext context) => MatchedBinomePairMatchesBloc(
                    matchedBinomePairMatchesRepository: matchedBinomePairMatchesRepository,
                    authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                  ),
                ),
                BlocProvider<DiscoverBinomePairMatchesBloc>(
                  create: (BuildContext context) => DiscoverBinomePairMatchesBloc(
                    discoverBinomePairMatchesRepository: discoverBinomePairMatchesRepository,
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
                BlocProvider<BinomePairSearchBloc>(
                  create: (BuildContext context) => BinomePairSearchBloc(
                    binomePairRepository: binomePairRepository,
                    matchedBinomePairMatchesRepository: matchedBinomePairMatchesRepository,
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
  });
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
              // If user if TSP 1A, check if he has a binome pair
              if (userState.user.year == TSPYear.TSP1A &&
                  userState.user.school == School.TSP) {
                return BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(
                  builder: (BuildContext context,
                      MatchedBinomesState matchedBinomePairMatchesState) {
                    if (matchedBinomePairMatchesState is MatchedBinomesInitialState ||
                        matchedBinomePairMatchesState
                            is MatchedBinomesHasBinomePairCheckedFailedState) {
                      BlocProvider.of<MatchedBinomesBloc>(context)
                          .add(MatchedBinomesCheckHasBinomePairEvent());
                      return SplashScreen();
                    }
                    if (matchedBinomePairMatchesState
                        is MatchedBinomesCheckingHasBinomePairState) {
                      return SplashScreen();
                    }
                    return TinterHome();
                  },
                );
              }
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
  final List<Widget> tabsBinomePair = [BinomesTab(), DiscoverBinomePairTab(), UserTab()];

  @override
  _TinterHomeState createState() => _TinterHomeState();
}

class _TinterHomeState extends State<TinterHome> {
  final GlobalKey discoverIconKey = GlobalKey();
  int _selectedTab = 2;
  OverlayEntry introduceBinomeOfBinomeOverlayEntry;

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Scaffold(
          backgroundColor: tinterTheme.colors.background,
          body: child,
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: _onItemTapped,
            selectedIndex: _selectedTab,
            discoverIconKey: discoverIconKey,
          ),
        );
      },
      child: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> sharedPreferences) {
          if (!sharedPreferences.hasData) return SplashScreen();
          return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(builder:
                (BuildContext context, MatchedBinomesState matchedBinomePairMatchesState) {
              bool _hasEverHadBinome =
                  sharedPreferences.data.getBool('hasEverHadBinome') ?? false;
              if ((matchedBinomePairMatchesState
                          as MatchedBinomesHasBinomePairCheckedSuccessState)
                      .hasBinomePair &&
                  !_hasEverHadBinome &&
                  introduceBinomeOfBinomeOverlayEntry == null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (tinterTheme.theme != MyTheme.light) {
                    tinterTheme.changeTheme();
                  }
                  _onItemTapped(0);

                  introduceBinomeOfBinomeOverlayEntry = OverlayEntry(
                    builder: (context) {
                      return IntroduceBinomeOfBinomeOverlay(
                        removeSelf: () =>
                            removeIntroduceBinomeOfBinomeOverlay(sharedPreferences.data),
                        discoverIconKey: discoverIconKey,
                      );
                    },
                  );
                  // Wait for the animation of the bottom nav bar
                  Future.delayed(Duration(milliseconds: 500), () {
                    Overlay.of(context).insert(introduceBinomeOfBinomeOverlayEntry);
                  });
                });
              }
              return tinterTheme.theme == MyTheme.dark
                  ? widget.tabsAssociatif[_selectedTab]
                  : (matchedBinomePairMatchesState
                              as MatchedBinomesHasBinomePairCheckedSuccessState)
                          .hasBinomePair
                      ? widget.tabsBinomePair[_selectedTab]
                      : widget.tabsScolaire[_selectedTab];
            });
          });
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    _selectedTab = index;
    setState(() {});
  }

  removeIntroduceBinomeOfBinomeOverlay(SharedPreferences sharedPreferences) async {
    await sharedPreferences.setBool('hasEverHadBinome', true);
    introduceBinomeOfBinomeOverlayEntry.remove();
    _onItemTapped(1);
  }
}

class IntroduceBinomeOfBinomeOverlay extends StatelessWidget {
  final VoidCallback removeSelf;
  final GlobalKey discoverIconKey;

  IntroduceBinomeOfBinomeOverlay({@required this.removeSelf, @required this.discoverIconKey});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = discoverIconKey.currentContext.findRenderObject();
    var buttonSize = renderBox.size;
    var buttonOffset = renderBox.localToGlobal(Offset.zero);

    return GestureDetector(
      onTapUp: (details) {
        if (details.globalPosition.dx < buttonOffset.dx + buttonSize.width + 10 &&
            details.globalPosition.dx > buttonOffset.dx - 10 &&
            details.globalPosition.dy > buttonOffset.dy + 10 &&
            details.globalPosition.dy < buttonOffset.dy + buttonSize.height - 10) {
          removeSelf();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: ClipPath(
          clipper: InvertedClipperDiscoverIcon(
            discoverIconKey: discoverIconKey,
          ),
          child: Container(
            color: Colors.black54,
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Nouvelle fonctionnalitée!',
                            style: tinterTheme.textStyle.headline2
                                .copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Maintenant que tu as trouvé.e ton ou ta binome, la page discover "
                            "te propose des binomes de binome afin de former un quadrinome!",
                            style: tinterTheme.textStyle.dialogContent
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class InvertedClipperDiscoverIcon extends CustomClipper<Path> {
  final GlobalKey discoverIconKey;

  InvertedClipperDiscoverIcon({@required this.discoverIconKey});

  @override
  Path getClip(Size size) {
    RenderBox renderBox = discoverIconKey.currentContext.findRenderObject();
    var buttonSize = renderBox.size;
    var buttonOffset = renderBox.localToGlobal(Offset.zero);

    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(
        center: Offset(
            buttonOffset.dx + buttonSize.width / 2, buttonOffset.dy + buttonSize.height / 2),
        radius: buttonSize.width / 2 + 10,
      ))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
