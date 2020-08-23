library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/associatif/match.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/associatif/searched_user_associatif.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';
import 'package:tinter_backend/models/scolaire/user_scolaire.dart';
import 'package:tinter_backend/models/shared/session.dart';
import 'package:tinter_backend/models/shared/token.dart';
import 'package:tinter_backend/models/shared/user_shared_part.dart';
import 'package:built_collection/built_collection.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  BuildUserSharedPart,
  BuildUserScolaire,
  BuildUserAssociatif,
  BuildMatch,
  MatchStatus,
  BuildBinome,
  BinomeStatus,
  SearchedUserAssociatif,
  SearchedUserScolaire,
  EnumRelationStatusAssociatif,
  RelationStatusAssociatif,
  Association,
  Token,
  RelationScoreAssociatif,
  Session,
  bool
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
