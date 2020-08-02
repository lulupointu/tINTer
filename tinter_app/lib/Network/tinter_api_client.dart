import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class TinterApiClient {
  static const baseUrl = '127.0.0.1';
  final http.Client httpClient;

  TinterApiClient({@required this.httpClient}):
      assert(httpClient!=null);
}