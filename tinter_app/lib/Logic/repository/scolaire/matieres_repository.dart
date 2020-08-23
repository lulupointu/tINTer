import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:meta/meta.dart';

class MatieresRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  MatieresRepository(
      {@required this.tinterAPIClient, @required this.authenticationRepository}) :
        assert(tinterAPIClient != null);


  Future<List<String>> getAllMatieres() async {

    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    TinterApiResponse<List<String>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllMatieres(token: token);
    } on TinterAPIError catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }


}