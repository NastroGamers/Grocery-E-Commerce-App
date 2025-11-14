import 'package:json_annotation/json_annotation.dart';

part 'whatsapp_model.g.dart';

@JsonSerializable()
class WhatsAppMessage {
  @JsonKey(name: 'message_id')
  final String? messageId;

  @JsonKey(name: 'to')
  final String to;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'type')
  final String type; // 'order_update', 'support', 'promotional'

  @JsonKey(name: 'template_name')
  final String? templateName;

  @JsonKey(name: 'template_params')
  final Map<String, dynamic>? templateParams;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const WhatsAppMessage({
    this.messageId,
    required this.to,
    required this.message,
    required this.type,
    this.templateName,
    this.templateParams,
    this.status,
    this.createdAt,
  });

  factory WhatsAppMessage.fromJson(Map<String, dynamic> json) =>
      _$WhatsAppMessageFromJson(json);

  Map<String, dynamic> toJson() => _$WhatsAppMessageToJson(this);
}

@JsonSerializable()
class SendWhatsAppRequest {
  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'template_name')
  final String? templateName;

  @JsonKey(name: 'template_params')
  final Map<String, dynamic>? templateParams;

  const SendWhatsAppRequest({
    required this.phone,
    required this.message,
    this.templateName,
    this.templateParams,
  });

  factory SendWhatsAppRequest.fromJson(Map<String, dynamic> json) =>
      _$SendWhatsAppRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendWhatsAppRequestToJson(this);
}

@JsonSerializable()
class WhatsAppSettings {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'order_updates_enabled')
  final bool orderUpdatesEnabled;

  @JsonKey(name: 'promotional_messages_enabled')
  final bool promotionalMessagesEnabled;

  @JsonKey(name: 'support_messages_enabled')
  final bool supportMessagesEnabled;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  const WhatsAppSettings({
    required this.userId,
    required this.orderUpdatesEnabled,
    required this.promotionalMessagesEnabled,
    required this.supportMessagesEnabled,
    this.phoneNumber,
    required this.isVerified,
  });

  factory WhatsAppSettings.fromJson(Map<String, dynamic> json) =>
      _$WhatsAppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$WhatsAppSettingsToJson(this);

  WhatsAppSettings copyWith({
    String? userId,
    bool? orderUpdatesEnabled,
    bool? promotionalMessagesEnabled,
    bool? supportMessagesEnabled,
    String? phoneNumber,
    bool? isVerified,
  }) {
    return WhatsAppSettings(
      userId: userId ?? this.userId,
      orderUpdatesEnabled: orderUpdatesEnabled ?? this.orderUpdatesEnabled,
      promotionalMessagesEnabled:
          promotionalMessagesEnabled ?? this.promotionalMessagesEnabled,
      supportMessagesEnabled:
          supportMessagesEnabled ?? this.supportMessagesEnabled,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
