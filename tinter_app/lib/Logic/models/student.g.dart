// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
    json['name'],
    json['surname'],
    json['email'],
    json['primoEntrant'],
    json['associations'],
    json['attiranceVieAsso'],
    json['feteOuCours'],
    json['aideOuSortir'],
    json['organisationEvenements'],
    json['goutsMusicaux'],
  );
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
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
