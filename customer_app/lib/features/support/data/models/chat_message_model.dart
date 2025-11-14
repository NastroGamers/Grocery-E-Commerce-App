import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  final String id;
  final String channelId;
  final String senderId;
  final String senderName;
  final String senderType; // 'customer', 'support', 'system'
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final List<String>? attachments;
  final String? replyToId;

  ChatMessageModel({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.attachments,
    this.replyToId,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  ChatMessageModel copyWith({
    String? id,
    String? channelId,
    String? senderId,
    String? senderName,
    String? senderType,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    List<String>? attachments,
    String? replyToId,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderType: senderType ?? this.senderType,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachments: attachments ?? this.attachments,
      replyToId: replyToId ?? this.replyToId,
    );
  }
}
