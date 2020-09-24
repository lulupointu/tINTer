import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';

part 'notification_relation_status_title.g.dart';

class NotificationRelationStatusTitle extends EnumClass {
  static const NotificationRelationStatusTitle relationStatusAssociatifUpdate = _$relationStatusAssociatifUpdate;
  static const NotificationRelationStatusTitle relationStatusScolaireUpdate = _$relationStatusScolaireUpdate;
  static const NotificationRelationStatusTitle relationStatusBinomeUpdate = _$relationStatusBinomeUpdate;


  const NotificationRelationStatusTitle._(String name) : super(name);

  static BuiltSet<NotificationRelationStatusTitle> get values => _$notificationRelationStatusTitleValues;
  static NotificationRelationStatusTitle valueOf(String name) => _$notificationRelationStatusTitleValueOf(name);

  String serialize() {
    return serializers.serializeWith(NotificationRelationStatusTitle.serializer, this);
  }

  static NotificationRelationStatusTitle deserialize(String string) {
    return serializers.deserializeWith(NotificationRelationStatusTitle.serializer, string);
  }

  static Serializer<NotificationRelationStatusTitle> get serializer => _$notificationRelationStatusTitleSerializer;
}