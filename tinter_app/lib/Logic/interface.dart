//import 'dart:convert';
//
//import 'package:flutter/foundation.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:property_change_notifier/property_change_notifier.dart';
//
//
///// Match is User with additional
///// information describing the user relation
///// with the match.
///// A match can be in one of four states:
/////   -1: Ignored
/////    0: No relation
/////    1: Liked One-Side
/////    2: Liked Two-Side
/////    3: Parrain You Asked
/////    4: Parrain He/She Asked
/////    5: Parrain (Accepted both side)
//class Match extends User {
//  int score;
//  int state;
//
//  Match(this.score, this.state, name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
//      aideOuSortir, organisationEvenements, goutsMusicaux):
//      super(name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
//          aideOuSortir, organisationEvenements, goutsMusicaux);
//
//  Match.fromJson(Map<String, dynamic> json) :
//        score = json['score'],
//        state = json['state'],
//    super.fromJson(json);
//}
//
//
///// User is a class describing the logged in user.
///// It is used to link he other different classes
///// use to describe the user.
//class User extends PropertyChangeNotifier<String> {
//  User user;
//  List<Match> _discoverMatches;
//  List<Match> _matchedMatches;
//  List<Match> _parrainMatches;
//
//  // region Getters for all variables
//  List<Match> get discoverMatches =>  _discoverMatches;
//  List<Match> get matchedMatches =>  _matchedMatches;
//  List<Match> get parrainMatches =>  _parrainMatches;
//  // endregion
//
//
//  // region Test methods
//  User.createTestUser():
//    user=User.fromJson({
//      'name': 'Lucas',
//      'surname': 'Delsol',
//      'email': 'lucasdelsol@telecom-sudparis.eu',
//      'primoEntrant': true,
//      'associations': Associations([
//        Association(
//          name: 'Association1',
//          description: 'This is the first association',
//        ),
//        Association(
//          name: 'Association2',
//          description: 'This is the second association',
//        ),
//        Association(
//          name: 'Association3',
//          description: 'This is the third association',
//        ),
//        Association(
//          name: 'Association1',
//          description: 'This is the first association',
//        ),
//        Association(
//          name: 'Association2',
//          description: 'This is the second association',
//        ),
//        Association(
//          name: 'Association3',
//          description: 'This is the third association',
//        ),
//        Association(
//          name: 'Association1',
//          description: 'This is the first association',
//        ),
//        Association(
//          name: 'Association2',
//          description: 'This is the second association',
//        ),
//        Association(
//          name: 'Association3',
//          description: 'This is the third association',
//        ),
//      ]),
//      'attiranceVieAsso': 0.56,
//      'feteOuCours': 0.24,
//      'aideOuSortir': 0.41,
//      'organisationEvenements': 0.12,
//      'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//    }),
//        _discoverMatches= [
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Name2',
//            'surname': 'Surname2',
//            'score': 65,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'AssociationX',
//                description: 'This is the X association',
//              ),
//              Association(
//                name: 'AssociationY',
//                description: 'This is the Y association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.21,
//            'feteOuCours': 0.94,
//            'aideOuSortir': 0.43,
//            'organisationEvenements': 0.45,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock', 'ok'])
//          }),
//          Match.fromJson({
//            'name': 'Name3',
//            'surname': 'Surname3',
//            'score': 23,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'AssociationZ',
//                description: 'This is the Z association',
//              ),
//              Association(
//                name: 'AssociationZZ',
//                description: 'This is the ZZ association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//        ],
//        _matchedMatches= [
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 1,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 2,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 3,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 4,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 5,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 6,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'primoEntrant': true,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//        ],
//        _parrainMatches= [
//          Match.fromJson({
//            'name': 'Valentine',
//            'surname': 'Coste',
//            'score': 99,
//            'state': 0,
//            'associations': Associations([
//              Association(
//                name: 'Association1',
//                description: 'This is the first association',
//              ),
//              Association(
//                name: 'Association2',
//                description: 'This is the second association',
//              ),
//              Association(
//                name: 'Association3',
//                description: 'This is the third association',
//              ),
//            ]),
//            'attiranceVieAsso': 0.56,
//            'feteOuCours': 0.24,
//            'aideOuSortir': 0.41,
//            'organisationEvenements': 0.12,
//            'goutsMusicaux': GoutsMusicaux(['Pop', 'Rock'])
//          }),
//        ];
//
//  void testDiscoverLike() async {
//    // Change locally
//    Match match = _discoverMatches.removeAt(0);
//    _matchedMatches.add(match);
//  }
//
//  // endregion
//
//
//  // region Init methods used to initiate the attributes
//  void init() async {
//    initUser();
//    initDiscoverMatches();
//    initMatchedMatches();
//    initParrainMatches();
//  }
//
//  void initUser() async {
//    user = await Interface.getUser();
//  }
//
//  void initDiscoverMatches() async {
//    _discoverMatches = await Interface.getDiscoverMatches();
//  }
//
//  void initMatchedMatches() async {
//    _matchedMatches = await Interface.getMatchedMatches();
//  }
//
//  void initParrainMatches() async {
//    _parrainMatches = await Interface.getParrainMatches();
//  }
//  // endregion
//
//
//  // region Methods to handle user like or ignore in the discover tab.
//  void discoverLike() async {
//    // Change locally
//    Match match = _discoverMatches.removeAt(0);
//    _matchedMatches.add(match);
//
//    // Update the database
//    await Interface.setMatchState(match, 1);
//
//    // Get a new match for discover
//    initDiscoverMatches();
//  }
//
//  void discoverIgnore() async {
//    // Change locally
//    Match match = _discoverMatches.removeAt(0);
//
//    // Update the database
//    Interface.setMatchState(match, -1);
//
//    // Get new matches for discover
//    initDiscoverMatches();
//  }
//  // endregion
//
//
//  // region Methods to handle user unlike, patronage asking or accepting in the matched tab.
//  /// unlike is triggered when a user unlikes
//  /// a match in the matched tab.
//  matchedUnlike(Match match) {
//    // Change locally
//    _matchedMatches.remove(match);
//
//    // Update the database
//    Interface.setMatchState(match, -1);
//  }
//
//  /// askPatronage is triggered when a user ask
//  /// a match for a patronage in the matched tab.
//  matchedAskPatronage(Match match) {
//    // Change locally
//    _matchedMatches[_matchedMatches.indexOf(match)].state = 2;
//
//    // Let the server know that a user was liked
//    Interface.setMatchState(match, 2);
//  }
//
//  /// unlike is triggered when a user unlikes
//  /// a match in the matched tab.
//  matchedAcceptPatronage(Match match) {
//    // Change locally
//    _matchedMatches.remove(match);
//    match.state = 3;
//    _parrainMatches.add(match);
//
//    // Let the server know that a user was liked
//    Interface.setMatchState(match, 3);
//  }
//  // endregion
//
//}
//
//
///// Interface is the class used to communicate with the server.
///// Every operation to or from the server is handled here
///// TODO: Handle errors from the connection.
///// Http get are you to initialise data.
///// Http post are used to modify information.
///// A Websocket is used to receive notifications
///// if any information changes. This can occur
///// for two main reasons:
/////     - The user operates on two devices at the same time
/////     - The user does something with causes other part of the app to change.
//class Interface {
//  static const SESSION_COOKIE_NAME = "Session_cookie";
//  static String SESSION_COOKIE;
//  static const SERVER_IP = 'ws://86.193.242.149:8080';
//  static IOWebSocketChannel webSocketChannel;
//  static Stream webSocketStream = webSocketChannel.stream;
//  // Don't forget to close : webSocketChannel.sink.close();
//
//  /// initWebSocketConnection start the WebSocket connection
//  /// with the server using SESSION_COOKIE.
//  void initWebSocketConnection() async {
//    webSocketChannel = IOWebSocketChannel.connect(
//        SERVER_IP + "/initWebSocketConnection",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE}
//    );
//  }
//
//  /// authenticate can be use to try to authenticate the user.
//  /// If the authentication is successful, stores the session
//  /// cookie in SESSION_COOKIE_NAME in the shared preferences.
//  Future<bool> authenticate({@required String username, @required String password}) async {
//
//      // Send the authentication request to the server
//      http.Response response = await http.post(
//        SERVER_IP + "/authenticate",
//        body: {
//          'username': username,
//          'password': password
//        }
//      );
//
//      /// TODO: Differentiate between bad connexion and wrong authentication
//      if (response.statusCode < 400) {
//        return false;
//      }
//
//      // Authentication successful, store the session cookie
//      SESSION_COOKIE = response.headers[SESSION_COOKIE_NAME];
//
//      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//      sharedPreferences.setString(SESSION_COOKIE_NAME, SESSION_COOKIE);
//
//      return true;
//  }
//
//  /// dispose closes the webSocketChannel.
//  void dispose() {
//    webSocketChannel?.sink?.close();
//  }
//
//  /// printHttpError prints an http error
//  static void printHTTPError(int statusCode) {
//    print("Error. Status code: " + statusCode.toString());
//  }
//
//
//  // region Getters used by the "User tab" to get the user user information from the database.
//  static Future<User> getUser() async {
//    http.Response response = await http.get(
//        SERVER_IP + "/User/Get",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return null;
//    }
//
//    User user = User.fromJson(jsonDecode(response.body));
//
//    return user;
//  }
//  // endregion
//
//
//  // region Getters used by the "Discover tab" or the "Matches tab" to get the user's matches from the database.
//  /// getDiscoverMatches loads the 10 first matches
//  /// which are to appear in the Discover tab.
//  static Future<List<Match>> getDiscoverMatches() async {
//    http.Response response = await http.get(
//        SERVER_IP + "/Matches/Get/Discover",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return [];
//    }
//
//    List<Match> discoverMatches = [];
//    response.body.split(",").forEach((match) {
//      discoverMatches.add(Match.fromJson(jsonDecode(match)));
//    });
//
//    return discoverMatches;
//  }
//
//
//  static Future<List<Match>> getMatchedMatches() async {
//    http.Response response = await http.get(
//        SERVER_IP + "/Matches/Get/Discover",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return [];
//    }
//
//    List<Match> matchedMatches = [];
//    response.body.split(",").forEach((match) {
//      matchedMatches.add(Match.fromJson(jsonDecode(match)));
//    });
//
//    return matchedMatches;
//  }
//
//
//  static Future<List<Match>> getParrainMatches() async {
//    http.Response response = await http.get(
//        SERVER_IP + "/Matches/Get/Discover",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return [];
//    }
//
//    List<Match> parrainMatches = [];
//    response.body.split(",").forEach((match) {
//      parrainMatches.add(Match.fromJson(jsonDecode(match)));
//    });
//
//    return parrainMatches;
//  }
//  // endregion
//
//
//  // region Setters used by the "User tab" to modify the user user in the database.
//  static Future<void> setAssociations(Associations newAssociations) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'associations': newAssociations.toString()}// TODO: json encode
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//  }
//
//  static Future<void> setAttiranceVieAsso(double newAttiranceVieAsso) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'attiranceVieAsso': newAttiranceVieAsso}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//
//  }
//
//  static Future<void> setFeteOuCours(double newFeteOuCours) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'feteOuCours': newFeteOuCours}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//
//  }
//
//  static Future<void> setAideOuSortir(double newAideOuSortir) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'aideOuSortir': newAideOuSortir}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//
//  }
//
//  static Future<void> setOrganisationEvenements(double newOrganisationEvenements) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'organisationEvenements': newOrganisationEvenements}
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//  }
//
//  static Future<void> setGoutsMusicaux(List<String> newGoutsMusicaux) async {
//    http.Response response = await http.post(
//        SERVER_IP + "/User/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {'goutsMusicaux': newGoutsMusicaux.toString()} // TODO: json encode
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//  }
//  // endregion
//
//
//  // region Setters used by the "Discover tab" or the "Matches tab" to modify the user relation with another user.
//  /// setMatchState changes the state of a match.
//  static Future<void> setMatchState(Match match, int state) async {
//    assert(state>-1 && state<3);
//
//    http.Response response = await http.post(
//        SERVER_IP + "/Matches/Set",
//        headers: {SESSION_COOKIE_NAME: SESSION_COOKIE},
//        body: {
//          'match': match,
//          'state': state
//        }
//    );
//
//    // TODO: Return error if server error
//    if (response.statusCode>400) {
//      printHTTPError(response.statusCode);
//      return;
//    }
//
//    return;
//  }
//  // endregion
//
//}
//
//class GoutsMusicaux {
//  List<String> _list;
//  var onUpdate;
//
//  GoutsMusicaux(List<String> goutsMusicaux):
//      _list = goutsMusicaux {
//      onUpdate = () {
//        Interface.setGoutsMusicaux(_list);
//      };
//  }
//
//  List<String> get get => _list;
//
//  bool contains(String value) {
//    return _list.contains(value);
//  }
//
//  add(String value) {
//    _list.add(value);
//    onUpdate();
//  }
//
//  bool remove(String value) {
//    bool isRemoved = _list.remove(value);
//    onUpdate();
//
//    return isRemoved;
//  }
//
//}
//
//class Association {
//  final String name;
//  final String description;
//  // TODO: Add logo
//
//  Association({this.name, this.description});
//}
//
//class Associations {
//  List<Association> _list;
//  var onUpdate;
//
//  Associations(List<Association> associations):
//        _list = associations {
//    onUpdate = () {
//      Interface.setAssociations(this);
//    };
//  }
//
//  operator [](int index) => _list[index];
//
//  int get length => _list.length;
//
//  bool contains(Association association) {
//    return _list.contains(association);
//  }
//
//  int indexOf(Association association) {
//    return _list.indexOf(association);
//  }
//
//  add(Association association) {
//    _list.add(association);
//    onUpdate();
//  }
//
//  bool remove(Association association) {
//    bool isRemoved = _list.remove(association);
//    onUpdate();
//
//    return isRemoved;
//  }
//
//  Association removeAt(int index) {
//    Association association = _list.removeAt(index);
//    onUpdate();
//
//    return association;
//  }
//
//  /// Deep copy of the list
//  List<Association> toList() {
//    return List.from(_list);
//  }
//
//
//}