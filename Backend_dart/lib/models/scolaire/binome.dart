import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/serializers.dart';
import 'package:tinter_backend/models/shared/user.dart';

part 'binome.g.dart';

abstract class Binome extends Object implements User {
  BinomeStatus get statusScolaire;
  int get score;
}

abstract class BuildBinome
//    with User, User
    implements Binome, Built<BuildBinome, BuildBinomeBuilder> {


  BuildBinome._();
  factory BuildBinome([void Function(BuildBinomeBuilder) updates]) = _$BuildBinome;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildBinome.serializer, this);
  }

  static BuildBinome fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildBinome.serializer, json);
  }

  static Serializer<BuildBinome> get serializer => _$buildBinomeSerializer;
}
class BinomeStatus extends EnumClass {
  static const BinomeStatus heIgnoredYou = _$heIgnoredYou;
  static const BinomeStatus ignored = _$ignored;
  static const BinomeStatus none = _$none;
  static const BinomeStatus liked = _$liked;
  static const BinomeStatus matched = _$matched;
  static const BinomeStatus youAskedBinome = _$youAskedBinome;
  static const BinomeStatus heAskedBinome = _$heAskedBinome;
  static const BinomeStatus binomeAccepted = _$binomeAccepted;
  static const BinomeStatus binomeHeRefused = _$binomeHeRefused;
  static const BinomeStatus binomeYouRefused = _$binomeYouRefused;


  const BinomeStatus._(String name) : super(name);

  static BuiltSet<BinomeStatus> get values => _$binomeStatusValues;
  static BinomeStatus valueOf(String name) => _$binomeStatusValueOf(name);

  String serialize() {
    return serializers.serializeWith(BinomeStatus.serializer, this);
  }

  static BinomeStatus deserialize(String string) {
    return serializers.deserializeWith(BinomeStatus.serializer, string);
  }

  static Serializer<BinomeStatus> get serializer => _$binomeStatusSerializer;
}



//enum BinomeStatus {
//  heIgnoredYou,
//  ignored,
//  none,
//  liked,
//  matched,
//  youAskedBinome,
//  heAskedBinome,
//  binomeAccepted,
//  binomeHeRefused,
//  binomeYouRefused,
//}

//@JsonSerializable(explicitToJson: true)
//@immutable
//class Binome extends User {
//  final BinomeStatus _status;
//  int _score;
//
//  Binome({
//    @required String login,
//    @required String name,
//    @required String surname,
//    @required String email,
//    @required TSPYear year,
//    @required int score,
//    @required BinomeStatus status,
//    @required List<dynamic> associations,
//    @required GroupeOuSeul groupeOuSeul,
//    @required LieuDeVie lieuDeVie,
//    @required List<HoraireDeTravail> horairesDeTravail,
//    @required OutilDeTravail enligneOuNon,
//    @required List<String> matieresPreferees,
//    String profilePicturePath,
//  })  : assert(score >= 0, score <= 100),
//        assert(status != null),
//        _status = (status is String)
//            ? BinomeStatus.values
//                .firstWhere((binomeStatus) => binomeStatus.toString() == 'BinomeStatus.$status')
//            : status,
//        _score = score,
//        super(
//      login: login,
//       year: year,
//       groupeOuSeul: groupeOuSeul,
//       lieuDeVie: lieuDeVie,
//       horairesDeTravail: horairesDeTravail,
//       enligneOuNon: enligneOuNon,
//       matieresPreferees: matieresPreferees,
//        );
//
//  factory Binome.fromJson(Map<String, dynamic> json) => _$BinomeFromJson(json);
//
//  Map<String, dynamic> toJson() => _$BinomeToJson(this);
//
//  // Define all getter for the binome info
//  BinomeStatus get status => _status;
//
//  int get score => _score;
//
//  @override
//  List<Object> get props => [
//        ...super.props,
//        status,
//        score,
//      ];
//
//  @override
//  String toString() => this.login;
//}
