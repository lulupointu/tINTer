import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/scolaire/build_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';

class TinterAPIClient {
  static const baseUrl = 'thd-tinter.int-evry.fr:443';
  final http.Client httpClient;

  TinterAPIClient({@required this.httpClient}) : assert(httpClient != null);

  Future<TinterApiResponse<void>> logIn(
      {@required String login, @required String password}) async {
    http.Response response = await httpClient.post(Uri.http(baseUrl, '/login'), headers: {
      HttpHeaders.wwwAuthenticateHeader: base64Encode(utf8.encode('$login:$password'))
    });

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError(
          'Error ${response.statusCode}: ${utf8.decode(base64Decode(response.body))}', null);
    } else if (!response.headers.containsKey(HttpHeaders.wwwAuthenticateHeader)) {
      throw TinterAPIError('Error the header does not contain wwwAuthenticateHeader', null);
    }

    Token token;

    try {
      token = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: null, token: token);
  }

  Future<TinterApiResponse<void>> authenticateWithToken({@required Token token}) async {
    http.Response response = await httpClient.post(
        Uri.http(baseUrl, '/authenticate', {'shouldRefresh': 'true'}),
        headers: {HttpHeaders.wwwAuthenticateHeader: token.token});

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    } else if (!response.headers.containsKey(HttpHeaders.wwwAuthenticateHeader)) {
      throw TinterAPIError(
          'Error the header does not contain wwwAuthenticateHeader}', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> createUser(
      {@required BuildUser user, @required Token token}) async {
    // Convert the user to json and remove profilePictureLocalPath
    Map<String, dynamic> userJson = user.toJson();
    userJson.remove('profilePictureLocalPath');

    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/shared/create', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(userJson),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateUser(
      {@required BuildUser user, @required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/shared/update', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(user.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateUserProfilePicture(
      {@required String profilePictureLocalPath, @required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/shared/updateProfilePicture', {'shouldRefresh': 'false'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: File(profilePictureLocalPath).readAsBytesSync(),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: null);
  }

  Future<TinterApiResponse<void>> updateMatchRelationStatus(
      {@required RelationStatusAssociatif relationStatus, @required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/associatif/matchUpdateRelationStatusAssociatif',
          {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(relationStatus.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateBinomeRelationStatus(
      {@required RelationStatusScolaire relationStatus, @required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/scolaire/binomeUpdateRelationStatus', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(relationStatus.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateBinomePairMatchRelationStatus(
      {@required RelationStatusBinomePair relationStatus, @required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(
          baseUrl, '/scolaire/binomePairMatchUpdateRelationStatus', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(relationStatus.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<BuildUser>> getUser({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/shared/user/info', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    BuildUser user;
    try {
      user = BuildUser.fromJson(jsonDecode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }

    return TinterApiResponse(value: user, token: newToken);
  }

  Future<TinterApiResponse<BuildBinomePair>> getBinomePair({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/binomePair', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    BuildBinomePair binomePair;
    try {
      binomePair = BuildBinomePair.fromJson(jsonDecode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }

    return TinterApiResponse(value: binomePair, token: newToken);
  }

  Future<TinterApiResponse<List<SearchedUserAssociatif>>> getAllSearchedUsersAssociatifs(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/associatif/searchUsers', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<SearchedUserAssociatif> searchedUsers;
    print('USER ASSOCIATIFS ${json.decode(response.body)}');
    try {
      searchedUsers = json
          .decode(response.body)
          .map<SearchedUserAssociatif>((dynamic jsonSearchedUserAssociatif) =>
              SearchedUserAssociatif.fromJson(jsonSearchedUserAssociatif))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: searchedUsers, token: newToken);
  }

  Future<TinterApiResponse<List<SearchedUserScolaire>>> getAllSearchedUsersScolaires(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/searchUsers', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<SearchedUserScolaire> searchedUsers;
    try {
      print('SEARCHED USERS ${json.decode(response.body)}');
      searchedUsers = json
          .decode(response.body)
          .map<SearchedUserScolaire>((dynamic jsonSearchedUserScolaire) =>
              SearchedUserScolaire.fromJson(jsonSearchedUserScolaire))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: searchedUsers, token: newToken);
  }

  Future<TinterApiResponse<List<SearchedBinomePair>>> getAllSearchedBinomePaired(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/searchBinomePair', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<SearchedBinomePair> searchedUsers;
    try {
      searchedUsers = json
          .decode(response.body)
          .map<SearchedBinomePair>((dynamic jsonSearchedUserScolaire) =>
              SearchedBinomePair.fromJson(jsonSearchedUserScolaire))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: searchedUsers, token: newToken);
  }

  Future<TinterApiResponse<bool>> isKnownUser({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/isKnown', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    bool isKnown;
    try {
      isKnown = jsonDecode(response.body)['isKnown'];
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: isKnown, token: newToken);
  }

  Future<TinterApiResponse<bool>> hasBinomePair({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/hasBinomePair', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    bool isKnown;
    try {
      isKnown = jsonDecode(response.body)['hasBinomePair'];
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: isKnown, token: newToken);
  }

  Future<TinterApiResponse<List<BuildMatch>>> getMatchedMatches(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/associatif/matchedMatches', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildMatch> matchedMatches;
    try {
      matchedMatches = json
          .decode(response.body)
          .map<BuildMatch>((dynamic jsonMatch) => BuildMatch.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: matchedMatches, token: newToken);
  }

  Future<TinterApiResponse<List<BuildMatch>>> getDiscoverMatches(
      {@required Token token, @required int limit, @required int offset}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/associatif/discoverMatches',
          {'limit': limit.toString(), 'offset': offset.toString(), 'shouldRefresh': 'true'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildMatch> discoverMatches;
    try {
      discoverMatches = json
          .decode(response.body)
          .map<BuildMatch>((dynamic jsonMatch) => BuildMatch.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: discoverMatches, token: newToken);
  }

  Future<TinterApiResponse<List<BuildBinome>>> getMatchedBinomes(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/matchedBinomes', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildBinome> matchedBinomes;
    try {
      matchedBinomes = json
          .decode(response.body)
          .map<BuildBinome>((dynamic jsonMatch) => BuildBinome.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: matchedBinomes, token: newToken);
  }

  Future<TinterApiResponse<List<BuildBinome>>> getDiscoverBinomes(
      {@required Token token, @required int limit, @required int offset}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/discoverBinomes',
          {'limit': limit.toString(), 'offset': offset.toString(), 'shouldRefresh': 'true'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildBinome> discoverBinomes;
    try {
      discoverBinomes = json
          .decode(response.body)
          .map<BuildBinome>((dynamic jsonMatch) => BuildBinome.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: discoverBinomes, token: newToken);
  }

  Future<TinterApiResponse<List<BuildBinomePairMatch>>> getMatchedBinomePairsMatches(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/matchedBinomesPairMatches', {'shouldRefresh': 'true'}),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildBinomePairMatch> matchedBinomePairMatches;
    try {
      matchedBinomePairMatches = json
          .decode(response.body)
          .map<BuildBinomePairMatch>(
              (dynamic jsonMatch) => BuildBinomePairMatch.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: matchedBinomePairMatches, token: newToken);
  }

  Future<TinterApiResponse<List<BuildBinomePairMatch>>> getDiscoverBinomePairsMatches(
      {@required Token token, @required int limit, @required int offset}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/discoverBinomesPairMatches',
          {'limit': limit.toString(), 'offset': offset.toString(), 'shouldRefresh': 'true'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<BuildBinomePairMatch> discoverBinomePairMatches;
    try {
      discoverBinomePairMatches = json
          .decode(response.body)
          .map<BuildBinomePairMatch>(
              (dynamic jsonMatch) => BuildBinomePairMatch.fromJson(jsonMatch))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: discoverBinomePairMatches, token: newToken);
  }

  Future<TinterApiResponse<List<Association>>> getAllAssociations(
      {@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/shared/associations/allAssociations', {'shouldRefresh': 'true'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<Association> allAssociations;
    try {
      allAssociations = json
          .decode(response.body)
          .map<Association>((dynamic jsonAssociation) => Association.fromJson(jsonAssociation))
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: allAssociations, token: newToken);
  }

  Future<TinterApiResponse<List<String>>> getAllMatieres({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/scolaire/matieres/allMatieres', {'shouldRefresh': 'true'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<String> allMatieres;
    try {
      allMatieres = json
          .decode(response.body)
          .map<String>((dynamic matiere) => matiere.toString())
          .toList();
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: allMatieres, token: newToken);
  }

  Future<TinterApiResponse<void>> sendNotificationToken(
      {@required Token token, @required String notificationToken}) async {
    http.Response response = await httpClient.post(
        Uri.http(
            baseUrl, '/shared/setNotificationToken', {'shouldRefresh': 'true'}),
        headers: {
          HttpHeaders.wwwAuthenticateHeader: token.token,
        },
        body: jsonEncode({
          'notificationToken': notificationToken,
        }));

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> deleteUserAccount({@required Token token}) async {
    http.Response response = await httpClient.post(
      Uri.http(baseUrl, '/shared/delete', {'shouldRefresh': 'false'}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        (t) => t..token = response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }
}

class TinterAPIError implements Exception {
  final String error;
  final Token token;

  TinterAPIError(this.error, this.token);

  @override
  String toString() => '(${this.runtimeType}) $error';
}

class TinterApiResponse<T> {
  final T value;
  final Token token;

  TinterApiResponse({@required this.value, @required this.token});
}
