import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/relation_status.dart';

part 'relation_status_associatif.g.dart';

class EnumRelationStatusAssociatif extends EnumClass {
  static const EnumRelationStatusAssociatif none = _$none;
  static const EnumRelationStatusAssociatif ignored = _$ignored;
  static const EnumRelationStatusAssociatif liked = _$liked;
  static const EnumRelationStatusAssociatif askedParrain = _$askedParrain;
  static const EnumRelationStatusAssociatif acceptedParrain = _$acceptedParrain;
  static const EnumRelationStatusAssociatif refusedParrain = _$refusedParrain;

  const EnumRelationStatusAssociatif._(String name) : super(name);

  static BuiltSet<EnumRelationStatusAssociatif> get values =>
      _$enumRelationStatusAssociatifValues;

  static EnumRelationStatusAssociatif valueOf(String name) =>
      _$enumRelationStatusAssociatifValueOf(name);

  String serialize() {
    return serializers.serializeWith(EnumRelationStatusAssociatif.serializer, this);
  }

  static EnumRelationStatusAssociatif deserialize(String string) {
    return serializers.deserializeWith(EnumRelationStatusAssociatif.serializer, string);
  }

  static Serializer<EnumRelationStatusAssociatif> get serializer =>
      _$enumRelationStatusAssociatifSerializer;
}

abstract class RelationStatusAssociatif
    implements RelationStatus, Built<RelationStatusAssociatif, RelationStatusAssociatifBuilder> {
  @nullable
  String get login;

  String get otherLogin;

  EnumRelationStatusAssociatif get status;

  RelationStatusAssociatif._();

  factory RelationStatusAssociatif([void Function(RelationStatusAssociatifBuilder) updates]) =
      _$RelationStatusAssociatif;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationStatusAssociatif.serializer, this);
  }

  static RelationStatusAssociatif fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationStatusAssociatif.serializer, json);
  }

  static Serializer<RelationStatusAssociatif> get serializer =>
      _$relationStatusAssociatifSerializer;
}
//import 'package:equatable/equatable.dart';
//import 'package:json_annotation/json_annotation.dart';
//import 'package:meta/meta.dart';
//
//part 'relation_status.g.dart';
//
//enum EnumRelationStatusAssociatif {
//  none,
//  ignored,
//  liked,
//  askedParrain,
//  acceptedParrain,
//  refusedParrain,
//}
//
//@JsonSerializable(explicitToJson: true)
//class RelationStatusAssociatif extends Equatable {
//  final String login;
//  final String otherLogin;
//  final EnumRelationStatusAssociatif status;
//
//  const RelationStatusAssociatif({
//    @required this.login,
//    @required this.otherLogin,
//    @required this.status,
//  });
//
//  factory RelationStatusAssociatif.fromJson(Map<String, dynamic> json) => _$RelationStatusAssociatifFromJson(json);
//
//  Map<String, dynamic> toJson() => _$RelationStatusAssociatifToJson(this);
//
//  @override
//  List<Object> get props => [login, otherLogin, status];
//}
//
//EnumRelationStatusAssociatif getEnumRelationStatusAssociatifFromString(String status) =>
//    _$enumDecodeNullable(_$EnumRelationStatusAssociatifEnumMap, status);
