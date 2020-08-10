// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
    login: json['login'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    email: json['email'] as String,
    primoEntrant: json['primoEntrant'] as bool,
    associations: (json['associations'] as List)
        ?.map((e) => e == null ? null : Association.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    attiranceVieAsso: (json['attiranceVieAsso'] as num)?.toDouble(),
    feteOuCours: (json['feteOuCours'] as num)?.toDouble(),
    aideOuSortir: (json['aideOuSortir'] as num)?.toDouble(),
    organisationEvenements: (json['organisationEvenements'] as num)?.toDouble(),
    goutsMusicaux: (json['goutsMusicaux'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'login': instance.login,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'primoEntrant': instance.primoEntrant,
      'associations': instance.associations?.map((e) => e?.toJson())?.toList(),
      'attiranceVieAsso': instance.attiranceVieAsso,
      'feteOuCours': instance.feteOuCours,
      'aideOuSortir': instance.aideOuSortir,
      'organisationEvenements': instance.organisationEvenements,
      'goutsMusicaux': instance.goutsMusicaux,
    };
