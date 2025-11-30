// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  text: json['text'] as String,
  isUser: json['isUser'] as bool,
  thoughtSignature: json['thought_signature'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'isUser': instance.isUser,
      'thought_signature': instance.thoughtSignature,
    };
