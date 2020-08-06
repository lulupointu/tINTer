// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) {
  return Match(
    json['name'],
    json['surname'],
    json['email'],
    json['score'],
    json['status'],
    json['primoEntrant'],
    json['associations'],
    json['attiranceVieAsso'],
    json['feteOuCours'],
    json['aideOuSortir'],
    json['organisationEvenements'],
    json['goutsMusicaux'],
  );
}

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
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
  MatchStatus.ignored: 'ignored',
  MatchStatus.none: 'none',
  MatchStatus.liked: 'liked',
  MatchStatus.matched: 'matched',
  MatchStatus.youAskedParrain: 'youAskedParrain',
  MatchStatus.heAskedParrain: 'heAskedParrain',
  MatchStatus.ParrainAccepted: 'ParrainAccepted',
  MatchStatus.ParrainRefused: 'ParrainRefused',
};
