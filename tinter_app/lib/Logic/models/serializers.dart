library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/associatif/user_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/models/scolaire/user_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';
import 'package:built_collection/built_collection.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  UserSharedPart,
  UserScolaire,
  UserAssociatif,
  Match,
  MatchStatus,
  Binome,
  BinomeStatus,
  SearchedUserAssociatif,
  SearchedUserScolaire,
  EnumRelationStatusAssociatif,
  RelationStatusAssociatif,
  Association,
  Token,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
