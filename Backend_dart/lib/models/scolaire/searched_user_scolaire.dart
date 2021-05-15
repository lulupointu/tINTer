import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'searched_user_scolaire.g.dart';

abstract class SearchedUserScolaire implements Built<SearchedUserScolaire, SearchedUserScolaireBuilder> {
  String get login;
  String get name;
  String get surname;
  bool get liked;
  int get score;

  SearchedUserScolaire._();
  factory SearchedUserScolaire([void Function(SearchedUserScolaireBuilder) updates]) = _$SearchedUserScolaire;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchedUserScolaire.serializer, this);
  }

  static SearchedUserScolaire fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchedUserScolaire.serializer, json);
  }

  static Serializer<SearchedUserScolaire> get serializer => _$searchedUserScolaireSerializer;
}

//@JsonSerializable(explicitToJson: true)
///// This is the static part of every student
///// Meaning the part they can't change.
//class SearchedUser extends Equatable {
//  final String _login;
//  final String _name;
//  final String _surname;
//  final bool _liked;
//
//  SearchedUser({
//    @required login,
//    @required name,
//    @required surname,
//    @required liked,
//  })  : assert(login != null),
//        assert(name != null),
//        assert(surname != null),
//        assert(liked != null),
//        _login = login,
//        _name = name,
//        _surname = surname,
//        _liked = liked;
//
//  factory SearchedUser.fromJson(Map<String, dynamic> json) => _$SearchedUserFromJson(json);
//
//  Map<String, dynamic> toJson() => _$SearchedUserToJson(this);
//
//  // Define all getter for the user info
//  String get login => _login;
//
//  String get name => _name;
//
//  String get surname => _surname;
//
//  bool get liked => _liked;
//
//
//  @override
//  List<Object> get props =>
//      [
//        name,
//        surname,
//        liked
//      ];
//
//  Widget getProfilePicture({@required double height, @required double width}) {
//
//    return ClipOval(
//      child: FutureBuilder(
//        future: AuthenticationRepository.getAuthenticationToken(),
//        builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//          return (!snapshot.hasData)
//              ? Center(child: CircularProgressIndicator())
//              : Image.network(
//            Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login}).toString(),
//            headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//            height: height,
//            width: width,
//          );
//        },
//      ),
//    );
//  }
//}
