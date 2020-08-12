import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'relation_status.g.dart';

enum EnumRelationStatus {
  none,
  ignored,
  liked,
  askedParrain,
  acceptedParrain,
  refusedParrain,
}

@JsonSerializable(explicitToJson: true)
class RelationStatus extends Equatable {
  final String login;
  final String otherLogin;
  final EnumRelationStatus status;

  const RelationStatus({
    @required this.login,
    @required this.otherLogin,
    @required this.status,
  });

  factory RelationStatus.fromJson(Map<String, dynamic> json) => _$RelationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RelationStatusToJson(this);

  @override
  List<Object> get props => [login, otherLogin, status];
}

EnumRelationStatus getEnumRelationStatusFromString(String status) =>
    _$enumDecodeNullable(_$EnumRelationStatusEnumMap, status);
