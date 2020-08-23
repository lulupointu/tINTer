// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Association _$AssociationFromJson(Map<String, dynamic> json) {
  return Association(
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$AssociationToJson(Association instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
