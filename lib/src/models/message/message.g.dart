// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      senderId: json['senderId'] as String,
      recipientUserId: json['recipientUserId'] as String,
      recipientUserEmail: json['recipientUserEmail'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'recipientUserId': instance.recipientUserId,
      'recipientUserEmail': instance.recipientUserEmail,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
    };
