import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'user_shared_part.g.dart';

abstract class BuildUserSharedPart with UserSharedPart implements Built<BuildUserSharedPart, BuildUserSharedPartBuilder> {

  BuildUserSharedPart._();
  factory BuildUserSharedPart([void Function(BuildUserSharedPartBuilder) updates]) = _$BuildUserSharedPart;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildUserSharedPart.serializer, this);
  }

  static BuildUserSharedPart fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildUserSharedPart.serializer, json);
  }

  static Serializer<BuildUserSharedPart> get serializer => _$buildUserSharedPartSerializer;
}

abstract class UserSharedPart {
  String get login;

  String get name;

  String get surname;

  String get email;

  School get school;

  @nullable
  String get profilePictureLocalPath;

  BuiltList<Association> get associations;
}

class School extends EnumClass {
  static const School TSP = _$TSP;
  static const School IMTBS = _$IMTBS;


  const School._(String name) : super(name);

  static BuiltSet<School> get values => _$schoolValues;
  static School valueOf(String name) => _$schoolValueOf(name);

  String serialize() {
    return serializers.serializeWith(School.serializer, this);
  }

  static School deserialize(String string) {
    return serializers.deserializeWith(School.serializer, string);
  }

  static Serializer<School> get serializer => _$schoolSerializer;

}




//enum School { TSP, IMTBS }
//abstract class UserSharedPart implements Built<UserSharedPart, UserSharedPartBuilder> {
//  String get login;
//  String get name;
//  String get surname;
//  String get email;
//  School get school;
//  String get profilePictureLocalPath;
//  List<Association> get associations;
//
//  UserSharedPart._();
//
//  factory UserSharedPart([updates(UserSharedPartBuilder u)]) = $_UserSharedPart;

//  UserSharedPart({
//    @required login,
//    @required name,
//    @required surname,
//    @required email,
//    @required school,
//    profilePictureLocalPath,
//    List<dynamic> associations = const [],
//  })  : assert(login != null),
//        assert(name != null),
//        assert(surname != null),
//        _login = login,
//        _name = name,
//        _surname = surname,
//        _email = email,
//        _school = school,
//        _profilePictureLocalPath = profilePictureLocalPath,
//        _associations = associations
//            ?.map((var association) => (association is Association)
//            ? association
//            : Association.fromJson(association))
//            ?.toList() ??
//            List<Association>();
//
//  factory UserSharedPart.fromJson(Map<String, dynamic> json) => _$UserSharedPartFromJson(json);
//
//  Map<String, dynamic> toJson() => _$UserSharedPartToJson(this);
//
//  // Define all getter for the user info
//  String get login => _login;
//
//  String get name => _name;
//
//  String get surname => _surname;
//
//  String get email => _email;
//
//  School get school => _school;
//
//  String get profilePictureLocalPath => _profilePictureLocalPath;
//
//  List<Association> get associations => _associations;
//
//  Widget getProfilePicture({@required double height, @required double width}) {
//    if (_profilePictureLocalPath != null) {
//      return ClipOval(
//        child: Image.file(
//          File(_profilePictureLocalPath),
//          height: height,
//          width: width,
//        ),
//      );
//    }
//
//    return ClipOval(
//      child: FutureBuilder(
//        future: AuthenticationRepository.getAuthenticationToken(),
//        builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//          return (!snapshot.hasData)
//              ? Center(child: CircularProgressIndicator())
//              : Image.network(
//            Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login})
//                .toString(),
//            headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//            height: height,
//            width: width,
//          );
//        },
//      ),
//    );
//  }
//
//  @override
//  List<Object> get props => [
//    login,
//    name,
//    surname,
//    email,
//    school,
//    profilePictureLocalPath,
//    associations,
//  ];
//}
