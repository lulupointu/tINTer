import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session extends Equatable {
  final String token;
  final String login;
  final DateTime creationDate;
  final bool isValid;

  const Session({
    @required this.token,
    @required this.login,
    @required this.creationDate,
    @required this.isValid,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  List<Object> get props => [token, login, creationDate, isValid];
}

