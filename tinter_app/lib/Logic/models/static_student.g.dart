// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaticStudent _$StaticStudentFromJson(Map<String, dynamic> json) {
  return StaticStudent(
    login: json['login'],
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    primoEntrant: json['primoEntrant'],
  );
}

Map<String, dynamic> _$StaticStudentToJson(StaticStudent instance) =>
    <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'primoEntrant': instance.primoEntrant,
    };
