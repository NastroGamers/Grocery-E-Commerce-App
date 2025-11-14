import 'package:dio/dio.dart';
import '../models/chat_message_model.dart';
import '../models/support_ticket_model.dart';
import '../models/faq_model.dart';

abstract class SupportRemoteDataSource {
  Future<List<ChatMessageModel>> getChatHistory(String channelId, int page);
  Future<ChatMessageModel> sendMessage(String channelId, String message, List<String>? attachments);
  Future<void> markMessagesAsRead(String channelId, List<String> messageIds);
  Future<SupportTicketModel> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
    String? orderId,
    List<String>? attachments,
  });
  Future<List<SupportTicketModel>> getTickets({String? status, int page = 1});
  Future<SupportTicketModel> getTicketDetails(String ticketId);
  Future<void> closeTicket(String ticketId);
  Future<List<FAQModel>> getFAQs({String? category, String? searchQuery});
  Future<void> markFAQHelpful(String faqId, bool isHelpful);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final Dio dio;

  SupportRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ChatMessageModel>> getChatHistory(String channelId, int page) async {
    final response = await dio.get(
      '/support/chat/$channelId/messages',
      queryParameters: {'page': page, 'limit': 50},
    );

    return (response.data['data'] as List)
        .map((json) => ChatMessageModel.fromJson(json))
        .toList();
  }

  @override
  Future<ChatMessageModel> sendMessage(
    String channelId,
    String message,
    List<String>? attachments,
  ) async {
    final response = await dio.post(
      '/support/chat/$channelId/messages',
      data: {
        'message': message,
        'attachments': attachments,
      },
    );

    return ChatMessageModel.fromJson(response.data['data']);
  }

  @override
  Future<void> markMessagesAsRead(String channelId, List<String> messageIds) async {
    await dio.put(
      '/support/chat/$channelId/messages/read',
      data: {'messageIds': messageIds},
    );
  }

  @override
  Future<SupportTicketModel> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
    String? orderId,
    List<String>? attachments,
  }) async {
    final response = await dio.post(
      '/support/tickets',
      data: {
        'subject': subject,
        'description': description,
        'category': category,
        'priority': priority,
        'orderId': orderId,
        'attachments': attachments,
      },
    );

    return SupportTicketModel.fromJson(response.data['data']);
  }

  @override
  Future<List<SupportTicketModel>> getTickets({String? status, int page = 1}) async {
    final response = await dio.get(
      '/support/tickets',
      queryParameters: {
        'status': status,
        'page': page,
        'limit': 20,
      },
    );

    return (response.data['data'] as List)
        .map((json) => SupportTicketModel.fromJson(json))
        .toList();
  }

  @override
  Future<SupportTicketModel> getTicketDetails(String ticketId) async {
    final response = await dio.get('/support/tickets/$ticketId');
    return SupportTicketModel.fromJson(response.data['data']);
  }

  @override
  Future<void> closeTicket(String ticketId) async {
    await dio.put('/support/tickets/$ticketId/close');
  }

  @override
  Future<List<FAQModel>> getFAQs({String? category, String? searchQuery}) async {
    final response = await dio.get(
      '/support/faqs',
      queryParameters: {
        'category': category,
        'search': searchQuery,
      },
    );

    return (response.data['data'] as List)
        .map((json) => FAQModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> markFAQHelpful(String faqId, bool isHelpful) async {
    await dio.post(
      '/support/faqs/$faqId/feedback',
      data: {'isHelpful': isHelpful},
    );
  }
}
