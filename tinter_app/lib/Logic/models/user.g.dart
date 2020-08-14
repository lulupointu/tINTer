// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    login: json['login'],
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    primoEntrant: json['primoEntrant'],
    associations: json['associations'],
    attiranceVieAsso: json['attiranceVieAsso'],
    feteOuCours: json['feteOuCours'],
    aideOuSortir: json['aideOuSortir'],
    organisationEvenements: json['organisationEvenements'],
    goutsMusicaux: json['goutsMusicaux'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
