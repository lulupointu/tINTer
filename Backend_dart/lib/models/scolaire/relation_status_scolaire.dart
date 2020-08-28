import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'relation_status_scolaire.g.dart';

abstract class RelationStatusScolaire
    implements Built<RelationStatusScolaire, RelationStatusScolaireBuilder> {
  String get login;

  String get otherLogin;

  EnumRelationStatusScolaire get statusScolaire;

  RelationStatusScolaire._();

  factory RelationStatusScolaire([void Function(RelationStatusScolaireBuilder) updates]) =
      _$RelationStatusScolaire;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationStatusScolaire.serializer, this);
  }

  static RelationStatusScolaire fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationStatusScolaire.serializer, json);
  }

  static Serializer<RelationStatusScolaire> get serializer =>
      _$relationStatusScolaireSerializer;
}

class EnumRelationStatusScolaire extends EnumClass {
  static const EnumRelationStatusScolaire none = _$none;
  static const EnumRelationStatusScolaire ignored = _$ignored;
  static const EnumRelationStatusScolaire liked = _$liked;
  static const EnumRelationStatusScolaire askedBinome = _$askedBinome;
  static const EnumRelationStatusScolaire acceptedBinome = _$acceptedBinome;
  static const EnumRelationStatusScolaire refusedBinome = _$refusedBinome;

  const EnumRelationStatusScolaire._(String name) : super(name);

  static BuiltSet<EnumRelationStatusScolaire> get values => _$enumRelationStatusScolaireValues;

  static EnumRelationStatusScolaire valueOf(String name) =>
      _$enumRelationStatusScolaireValueOf(name);

  String serialize() {
    return serializers.serializeWith(EnumRelationStatusScolaire.serializer, this);
  }

  static EnumRelationStatusScolaire deserialize(String string) {
    return serializers.deserializeWith(EnumRelationStatusScolaire.serializer, string);
  }

  static Serializer<EnumRelationStatusScolaire> get serializer =>
      _$enumRelationStatusScolaireSerializer;
}

//enum EnumRelationStatusScolaire {
//  none,
//  ignored,
//  liked,
//  askedBinome,
//  acceptedBinome,
//  refusedBinome,
//}
//
//@JsonSerializable(explicitToJson: true)
//class RelationStatusScolaire extends Equatable {
//  final String login;
//  final String otherLogin;
//  final EnumRelationStatusScolaire status;
//
//  const RelationStatusScolaire({
//    @required this.login,
//    @required this.otherLogin,
//    @required this.status,
//  });
//
//  factory RelationStatusScolaire.fromJson(Map<String, dynamic> json) => _$RelationStatusScolaireFromJson(json);
//
//  Map<String, dynamic> toJson() => _$RelationStatusScolaireToJson(this);
//
//  @override
//  List<Object> get props => [login, otherLogin, status];
//}
//
//EnumRelationStatusScolaire getEnumRelationStatusScolaireFromString(String status) =>
//    _$enumDecodeNullable(_$EnumRelationStatusScolaireEnumMap, status);
