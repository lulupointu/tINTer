library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/associatif/match.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/associatif/searched_user_associatif.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/binome_pair_match.dart';
import 'package:tinter_backend/models/scolaire/relation_score_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/scolaire/searched_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_body.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_title.dart';
import 'package:tinter_backend/models/shared/session.dart';
import 'package:tinter_backend/models/shared/token.dart';
import 'package:tinter_backend/models/shared/user.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  BuildUser,
  BuildMatch,
  MatchStatus,
  BuildBinome,
  BinomeStatus,
  SearchedUserScolaire,
  SearchedUserAssociatif,
  EnumRelationStatusAssociatif,
  EnumRelationStatusScolaire,
  RelationStatusAssociatif,
  RelationStatusScolaire,
  Association,
  Token,
  RelationScoreAssociatif,
  RelationScoreScolaire,
  bool,
  HoraireDeTravail,
  Session,
  TSPYear,
  LieuDeVie,
  School,
  BuildBinomePair,
  BuildBinomePairMatch,
  RelationScoreBinomePair,
  RelationStatusBinomePair,
  EnumRelationStatusBinomePair,
  SearchedBinomePair,
  NotificationRelationStatusTitle,
  NotificationRelationStatusBody,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
