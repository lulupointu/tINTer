import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/relation_status.dart';

part 'notification_relation_status_body.g.dart';

abstract class NotificationRelationStatusBody
    implements Built<NotificationRelationStatusBody, NotificationRelationStatusBodyBuilder> {
  RelationStatus get relationStatus;

  NotificationRelationStatusBody._();

  factory NotificationRelationStatusBody(
          [void Function(NotificationRelationStatusBodyBuilder) updates]) =
      _$NotificationRelationStatusBody;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(NotificationRelationStatusBody.serializer, this);
  }

  static NotificationRelationStatusBody fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(NotificationRelationStatusBody.serializer, json);
  }

  static Serializer<NotificationRelationStatusBody> get serializer =>
      _$notificationRelationStatusBodySerializer;
}
