// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchedUser _$SearchedUserFromJson(Map<String, dynamic> json) {
  return SearchedUser(
    login: json['login'],
    name: json['name'],
    surname: json['surname'],
    liked: json['liked'],
  );
}

Map<String, dynamic> _$SearchedUserToJson(SearchedUser instance) =>
    <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'surname': instance.surname,
      'liked': instance.liked,
    };
