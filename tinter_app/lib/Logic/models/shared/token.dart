import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';

part 'token.g.dart';

abstract class Token implements Built<Token, TokenBuilder> {
  @nullable
  String get token;

  Token._();
  factory Token([void Function(TokenBuilder) updates]) = _$Token;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Token.serializer, this);
  }

  static Token fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Token.serializer, json);
  }

  static Serializer<Token> get serializer => _$tokenSerializer;
}

//@JsonSerializable(explicitToJson: true)
//class Token extends Equatable {
//  final String token;
//
//  const Token({@required this.token});
//
//  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
//
//  Map<String, dynamic> toJson() => _$TokenToJson(this);
//
//  @override
//  List<Object> get props => [token];
//}
