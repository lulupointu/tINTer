// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchedUserAssociatif _$SearchedUserAssociatifFromJson(
    Map<String, dynamic> json) {
  return SearchedUserAssociatif(
    login: json['login'],
    name: json['name'],
    surname: json['surname'],
    liked: json['liked'],
  );
}

Map<String, dynamic> _$SearchedUserAssociatifToJson(
        SearchedUserAssociatif instance) =>
    <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'surname': instance.surname,
      'liked': instance.liked,
    };