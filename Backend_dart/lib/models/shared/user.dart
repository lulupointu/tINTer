
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'user.g.dart';

abstract class BuildUser with User implements Built<BuildUser, BuildUserBuilder> {

  BuildUser._();
  factory BuildUser([void Function(BuildUserBuilder) updates]) = _$BuildUser;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildUser.serializer, this);
  }

  static BuildUser fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildUser.serializer, json);
  }

  static Serializer<BuildUser> get serializer => _$buildUserSerializer;
}

abstract class User extends Object {
  String get login;

  String get name;

  String get surname;

  String get email;

  School get school;

  @nullable
  String get profilePictureLocalPath;

  BuiltList<Association> get associations;

  // Attributes relative to the association part of the app
  bool get primoEntrant;

  double get attiranceVieAsso;

  double get feteOuCours;

  double get aideOuSortir;

  double get organisationEvenements;

  BuiltList<String> get goutsMusicaux;

  // Attributes relative to the scolaire part of the app
  TSPYear get year;

  LieuDeVie get lieuDeVie;

  double get groupeOuSeul;

  BuiltList<HoraireDeTravail> get horairesDeTravail;

  double get enligneOuNon;

  BuiltList<String> get matieresPreferees;
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


class TSPYear extends EnumClass {
  static const TSPYear TSP1A = _$TSP1A;
  static const TSPYear TSP2A = _$TSP2A;
  static const TSPYear TSP3A = _$TSP3A;

  const TSPYear._(String name) : super(name);

  static BuiltSet<TSPYear> get values => _$tSPYearValues;

  static TSPYear valueOf(String name) => _$tSPYearValueOf(name);

  String serialize() {
    return serializers.serializeWith(TSPYear.serializer, this);
  }

  static TSPYear deserialize(String string) {
    return serializers.deserializeWith(TSPYear.serializer, string);
  }

  static Serializer<TSPYear> get serializer => _$tSPYearSerializer;
}

class LieuDeVie extends EnumClass {
  static const LieuDeVie maisel = _$maisel;
  static const LieuDeVie other = _$other;

  const LieuDeVie._(String name) : super(name);

  static BuiltSet<LieuDeVie> get values => _$lieuDeVieValues;

  static LieuDeVie valueOf(String name) => _$lieuDeVieValueOf(name);

  String serialize() {
    return serializers.serializeWith(LieuDeVie.serializer, this);
  }

  static LieuDeVie deserialize(String string) {
    return serializers.deserializeWith(LieuDeVie.serializer, string);
  }

  static Serializer<LieuDeVie> get serializer => _$lieuDeVieSerializer;
}

class HoraireDeTravail extends EnumClass {
  static const HoraireDeTravail morning = _$morning;
  static const HoraireDeTravail afternoon = _$afternoon;
  static const HoraireDeTravail evening = _$evening;
  static const HoraireDeTravail night = _$night;

  const HoraireDeTravail._(String name) : super(name);

  static BuiltSet<HoraireDeTravail> get values => _$horaireDeTravailValues;

  static HoraireDeTravail valueOf(String name) => _$horaireDeTravailValueOf(name);

  String serialize() {
    return serializers.serializeWith(HoraireDeTravail.serializer, this);
  }

  static HoraireDeTravail deserialize(String string) {
    return serializers.deserializeWith(HoraireDeTravail.serializer, string);
  }

  static Serializer<HoraireDeTravail> get serializer => _$horaireDeTravailSerializer;
}



//enum School { TSP, IMTBS }
//abstract class User implements Built<User, UserBuilder> {
//  String get login;
//  String get name;
//  String get surname;
//  String get email;
//  School get school;
//  String get profilePictureLocalPath;
//  List<Association> get associations;
//
//  User._();
//
//  factory User([updates(UserBuilder u)]) = $_User;

//  User({
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
//  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//
//  Map<String, dynamic> toJson() => _$UserToJson(this);
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
