import 'package:json_annotation/json_annotation.dart';
import 'chat_message_model.dart';

part 'support_ticket_model.g.dart';

@JsonSerializable()
class SupportTicketModel {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final String status; // 'open', 'in_progress', 'resolved', 'closed'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String category; // 'order', 'payment', 'delivery', 'product', 'other'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final String? assignedTo;
  final List<ChatMessageModel>? messages;
  final String? orderId;
  final List<String>? attachments;

  SupportTicketModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    this.status = 'open',
    this.priority = 'medium',
    required this.category,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.assignedTo,
    this.messages,
    this.orderId,
    this.attachments,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupportTicketModelToJson(this);

  SupportTicketModel copyWith({
    String? id,
    String? userId,
    String? subject,
    String? description,
    String? status,
    String? priority,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? assignedTo,
    List<ChatMessageModel>? messages,
    String? orderId,
    List<String>? attachments,
  }) {
    return SupportTicketModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      messages: messages ?? this.messages,
      orderId: orderId ?? this.orderId,
      attachments: attachments ?? this.attachments,
    );
  }
}
