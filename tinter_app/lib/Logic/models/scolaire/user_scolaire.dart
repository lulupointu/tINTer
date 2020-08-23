import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';

part 'user_scolaire.g.dart';

abstract class UserScolaire extends Object with UserSharedPart {

  TSPYear get year;

  GroupeOuSeul get groupeOuSeul;

  LieuDeVie get lieuDeVie;

  BuiltList<HoraireDeTravail> get horairesDeTravail;

  OutilDeTravail get enligneOuNon;

  BuiltList<String> get matieresPreferees;
}


abstract class BuildUserScolaire with UserSharedPart implements UserScolaire ,Built<BuildUserScolaire, BuildUserScolaireBuilder> {

  BuildUserScolaire._();
  factory BuildUserScolaire([void Function(BuildUserScolaireBuilder) updates]) = _$BuildUserScolaire;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildUserScolaire.serializer, this);
  }

  static BuildUserScolaire fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildUserScolaire.serializer, json);
  }

  static Serializer<BuildUserScolaire> get serializer => _$buildUserScolaireSerializer;
}

class UserScolaireMutableAttribute extends EnumClass {
  static const UserScolaireMutableAttribute year = _$year;
  static const UserScolaireMutableAttribute groupeOuSeul = _$groupeOuSeul;
  static const UserScolaireMutableAttribute lieuDeVie = _$lieuDeVie;
  static const UserScolaireMutableAttribute horairesDeTravail = _$horairesDeTravail;
  static const UserScolaireMutableAttribute enligneOuNon = _$enligneOuNon;
  static const UserScolaireMutableAttribute matieresPreferees = _$matieresPreferees;

  const UserScolaireMutableAttribute._(String name) : super(name);

  static BuiltSet<UserScolaireMutableAttribute> get values =>
      _$userScolaireMutableAttributeValues;

  static UserScolaireMutableAttribute valueOf(String name) =>
      _$userScolaireMutableAttributeValueOf(name);

  String serialize() {
    return serializers.serializeWith(UserScolaireMutableAttribute.serializer, this);
  }

  static UserScolaireMutableAttribute deserialize(String string) {
    return serializers.deserializeWith(UserScolaireMutableAttribute.serializer, string);
  }

  static Serializer<UserScolaireMutableAttribute> get serializer =>
      _$userScolaireMutableAttributeSerializer;
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

class GroupeOuSeul extends EnumClass {
  static const GroupeOuSeul groupe = _$groupe;
  static const GroupeOuSeul seul = _$seul;

  const GroupeOuSeul._(String name) : super(name);

  static BuiltSet<GroupeOuSeul> get values => _$groupeOuSeulValues;

  static GroupeOuSeul valueOf(String name) => _$groupeOuSeulValueOf(name);

  String serialize() {
    return serializers.serializeWith(GroupeOuSeul.serializer, this);
  }

  static GroupeOuSeul deserialize(String string) {
    return serializers.deserializeWith(GroupeOuSeul.serializer, string);
  }

  static Serializer<GroupeOuSeul> get serializer => _$groupeOuSeulSerializer;
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

class OutilDeTravail extends EnumClass {
  static const OutilDeTravail online = _$online;
  static const OutilDeTravail faceToFace = _$faceToFace;

  const OutilDeTravail._(String name) : super(name);

  static BuiltSet<OutilDeTravail> get values => _$outilDeTravailValues;

  static OutilDeTravail valueOf(String name) => _$outilDeTravailValueOf(name);

  String serialize() {
    return serializers.serializeWith(OutilDeTravail.serializer, this);
  }

  static OutilDeTravail deserialize(String string) {
    return serializers.deserializeWith(OutilDeTravail.serializer, string);
  }

  static Serializer<OutilDeTravail> get serializer => _$outilDeTravailSerializer;
}

//enum OutilDeTravail {
//  online,
//  faceToFace,
//}
//enum HoraireDeTravail { morning, afternoon, evening, night }
//enum LieuDeVie { maisel, other }
//enum GroupeOuSeul { groupe, seul }
//enum TSPYear { TSP1A, TSP2A, TSP3A }

//enum UserScolaireMutableAttribute {
//  year,
//  groupeOuSeul,
//  lieuDeVie,
//  horairesDeTravail,
//  enligneOuNon,
//  matieresPreferees,
//}

//@JsonSerializable(explicitToJson: true)
//class UserScolaire extends UserSharedPart {
//  final TSPYear _year;
//  final GroupeOuSeul _groupeOuSeul;
//  final LieuDeVie _lieuDeVie;
//  final List<HoraireDeTravail> _horairesDeTravail;
//  final OutilDeTravail _enligneOuNon;
//  final List<String> _matieresPreferees;
//
//  UserScolaire({
//    @required login,
//    @required name,
//    @required surname,
//    @required email,
//    @required school,
//    profilePictureLocalPath,
//    List<dynamic> associations = const [],
//    @required TSPYear year,
//    @required GroupeOuSeul groupeOuSeul,
//    @required LieuDeVie lieuDeVie,
//    @required List<HoraireDeTravail> horairesDeTravail,
//    @required OutilDeTravail enligneOuNon,
//    @required List<String> matieresPreferees,
//    String profilePicturePath,
//  })  : assert(groupeOuSeul != 0),
//        assert(lieuDeVie != null),
//        assert(enligneOuNon != null),
//        _year = year,
//        _groupeOuSeul = groupeOuSeul,
//        _lieuDeVie = lieuDeVie,
//        _horairesDeTravail = horairesDeTravail
//                ?.map((dynamic horaireDeTravail) => horaireDeTravail.toString())
//                ?.toList() ??
//            List<HoraireDeTravail>(),
//        _enligneOuNon = enligneOuNon,
//        _matieresPreferees = matieresPreferees
//                ?.map((dynamic matieresPreferee) => matieresPreferee.toString())
//                ?.toList() ??
//            List<String>(),
//        super(
//          login: login,
//          name: name,
//          surname: surname,
//          email: email,
//          school: school,
//          profilePictureLocalPath: profilePictureLocalPath,
//          associations: associations,
//        );
//
//  factory UserScolaire.fromJson(Map<String, dynamic> json) => _$UserScolaireFromJson(json);
//
//  Map<String, dynamic> toJson() => _$UserScolaireToJson(this);
//
//  // Define all getter for the user info
//  TSPYear get year => _year;
//
//  GroupeOuSeul get groupeOuSeul => _groupeOuSeul;
//
//  LieuDeVie get lieuDeVie => _lieuDeVie;
//
//  List<HoraireDeTravail> get horairesDeTravail => _horairesDeTravail;
//
//  OutilDeTravail get enligneOuNon => _enligneOuNon;
//
//  List<String> get matieresPreferees => _matieresPreferees;
//
//  bool isAnyAttributeNull() {
//    return props.map((Object prop) => prop == null).contains(true);
//  }
//
//  @override
//  List<Object> get props => [
//        ...super.props,
//        year,
//        _groupeOuSeul,
//        _lieuDeVie,
//        _horairesDeTravail,
//        _enligneOuNon,
//        _matieresPreferees,
//      ];
//}
//
//GroupeOuSeul getGroupeOuSeulFromString(String status) =>
//    _$enumDecodeNullable(_$GroupeOuSeulEnumMap, status);
//
//LieuDeVie getLieuDeVieFromString(String status) =>
//    _$enumDecodeNullable(_$LieuDeVieEnumMap, status);
//
//HoraireDeTravail getHoraireDeTravailFromString(String status) =>
//    _$enumDecodeNullable(_$HoraireDeTravailEnumMap, status);
//
//OutilDeTravail getOutilDeTravailFromString(String status) =>
//    _$enumDecodeNullable(_$OutilDeTravailEnumMap, status);
