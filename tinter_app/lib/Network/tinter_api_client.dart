import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/relation_status.dart';
import 'package:tinterapp/Logic/models/static_student.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/models/user.dart';

class TinterApiClient {
  static const baseUrl = '10.0.2.2:4044';
  final http.Client httpClient;

  TinterApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<TinterApiResponse<void>> logIn({@required String login, @required String password}) async {
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
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: null, token: token);
  }

  Future<TinterApiResponse<void>> authenticateWithToken({@required Token token}) async {
    http.Response response = await httpClient.post(Uri.http(baseUrl, '/authenticate'),
        headers: {HttpHeaders.wwwAuthenticateHeader: token.token});

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    } else if (!response.headers.containsKey(HttpHeaders.wwwAuthenticateHeader)) {
      throw TinterAPIError('Error the header does not contain wwwAuthenticateHeader}', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> createUser({@required User user, @required Token token}) async {
    http.Response response = await httpClient.post(
      '$baseUrl/createUser',
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(user.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateUser({@required User user, @required Token token}) async {
    http.Response response = await httpClient.post(
      '$baseUrl/userUpdate',
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(user.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<void>> updateMatchRelationStatus(
      {@required RelationStatus relationStatus, @required Token token}) async {
    http.Response response = await httpClient.post(
      '$baseUrl/matchUpdateRelationStatus',
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
      body: json.encode(relationStatus.toJson()),
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    return TinterApiResponse(value: null, token: newToken);
  }

  Future<TinterApiResponse<StaticStudent>> getStaticStudent({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/user/staticInfo'),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }


    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    StaticStudent staticStudent;
    try {
      staticStudent = StaticStudent.fromJson(jsonDecode(response.body));
    } catch (error) {
      print(error);
      throw error;
    }

    return TinterApiResponse(value: staticStudent, token: newToken);
  }

  Future<TinterApiResponse<User>> getUser({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/user/info'),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    User user;
    try {
      user = User.fromJson(jsonDecode(response.body));
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: user, token: newToken);
  }

  Future<TinterApiResponse<bool>> isKnownUser({@required Token token}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/user/isKnown'),
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
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

  Future<TinterApiResponse<List<Match>>> getMatchedMatches({@required Token token}) async {
    http.Response response = await httpClient.get(
      '$baseUrl/matchedMatches',
      headers: {HttpHeaders.wwwAuthenticateHeader: token.token},
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<Match> matchedMatches;
    try {
      matchedMatches = json.decode(response.body).map((Map<String, dynamic> jsonMatch) => Match.fromJson(jsonMatch));
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: matchedMatches, token: newToken);
  }

  Future<TinterApiResponse<List<Match>>> getDiscoverMatches(
      {@required Token token, @required int limit, @required int offset}) async {
    http.Response response = await httpClient.get(
      Uri.http(baseUrl, '/discoverMatches', {'limit': limit.toString(), 'offset': offset.toString()}),
      headers: {
        HttpHeaders.wwwAuthenticateHeader: token.token,
      },
    );

    Token newToken;
    try {
      newToken = Token(
        token: response.headers[HttpHeaders.wwwAuthenticateHeader],
      );
    } catch (error) {
      throw error;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw TinterAPIError('Error ${response.statusCode}: (${response.body})', newToken);
    }

    List<Match> discoverMatches;
    try {
      discoverMatches = json.decode(response.body).map((Map<String, dynamic> jsonMatch) => Match.fromJson(jsonMatch));
    } catch (error) {
      throw error;
    }

    return TinterApiResponse(value: discoverMatches, token: newToken);
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