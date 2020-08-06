import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:tinterapp/Logic/models/token.dart';

class TinterApiClient {
  static const baseUrl = '127.0.0.1';
  final http.Client httpClient;

  TinterApiClient({@required this.httpClient}):
      assert(httpClient!=null);


  Token logIn({@required String login, @required String password}) {
      // TODO: implement login
    if (login == 'test' && password == 'test') {
      return Token(token: '56465fds65fsd6f5312fsd', expirationDate: DateTime.now());
    }
    return null;
  }

  Token logInWithToken({@required Token token}) {
    // TODO: implement login with token

    return null;
  }
}