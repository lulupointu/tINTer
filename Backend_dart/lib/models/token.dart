import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'token.g.dart';


@JsonSerializable(explicitToJson: true)
class Token extends Equatable {
  final String token;
  final DateTime expirationDate;

  const Token({@required this.token, @required this.expirationDate});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  List<Object> get props => [token, expirationDate];
}
