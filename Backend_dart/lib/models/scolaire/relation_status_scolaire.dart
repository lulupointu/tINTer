import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'relation_status_scolaire.g.dart';

enum EnumRelationStatusScolaire {
  none,
  ignored,
  liked,
  askedBinome,
  acceptedBinome,
  refusedBinome,
}

@JsonSerializable(explicitToJson: true)
class RelationStatusScolaire extends Equatable {
  final String login;
  final String otherLogin;
  final EnumRelationStatusScolaire status;

  const RelationStatusScolaire({
    @required this.login,
    @required this.otherLogin,
    @required this.status,
  });

  factory RelationStatusScolaire.fromJson(Map<String, dynamic> json) => _$RelationStatusScolaireFromJson(json);

  Map<String, dynamic> toJson() => _$RelationStatusScolaireToJson(this);

  @override
  List<Object> get props => [login, otherLogin, status];
}

EnumRelationStatusScolaire getEnumRelationStatusScolaireFromString(String status) =>
    _$enumDecodeNullable(_$EnumRelationStatusScolaireEnumMap, status);
