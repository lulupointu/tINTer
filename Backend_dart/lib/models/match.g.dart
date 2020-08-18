// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) {
  return Match(
    login: json['login'],
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    score: json['score'],
    status: json['status'],
    primoEntrant: json['primoEntrant'],
    associations: json['associations'],
    attiranceVieAsso: json['attiranceVieAsso'],
    feteOuCours: json['feteOuCours'],
    aideOuSortir: json['aideOuSortir'],
    organisationEvenements: json['organisationEvenements'],
    goutsMusicaux: json['goutsMusicaux'],
  );
}

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
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
      'status': _$MatchStatusEnumMap[instance.status],
      'score': instance.score,
    };

const _$MatchStatusEnumMap = {
  MatchStatus.heIgnoredYou: 'heIgnoredYou',
  MatchStatus.ignored: 'ignored',
  MatchStatus.none: 'none',
  MatchStatus.liked: 'liked',
  MatchStatus.matched: 'matched',
  MatchStatus.youAskedParrain: 'youAskedParrain',
  MatchStatus.heAskedParrain: 'heAskedParrain',
  MatchStatus.parrainAccepted: 'parrainAccepted',
  MatchStatus.parrainHeRefused: 'parrainHeRefused',
  MatchStatus.parrainYouRefused: 'parrainYouRefused',
};
