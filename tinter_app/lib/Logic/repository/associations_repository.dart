import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:meta/meta.dart';

class AssociationsRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  AssociationsRepository(
      {@required this.tinterAPIClient, @required this.authenticationRepository}) :
        assert(tinterAPIClient != null);


  Future<List<Association>> getAllAssociations() async {

    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    TinterApiResponse<List<Association>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllAssociations(token: token);
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