import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/models/faq_model.dart';

abstract class SupportRepository {
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory(String channelId, int page);
  Future<Either<Failure, ChatMessageModel>> sendMessage(String channelId, String message, List<String>? attachments);
  Future<Either<Failure, void>> markMessagesAsRead(String channelId, List<String> messageIds);
  Future<Either<Failure, SupportTicketModel>> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
    String? orderId,
    List<String>? attachments,
  });
  Future<Either<Failure, List<SupportTicketModel>>> getTickets({String? status, int page});
  Future<Either<Failure, SupportTicketModel>> getTicketDetails(String ticketId);
  Future<Either<Failure, void>> closeTicket(String ticketId);
  Future<Either<Failure, List<FAQModel>>> getFAQs({String? category, String? searchQuery});
  Future<Either<Failure, void>> markFAQHelpful(String faqId, bool isHelpful);
}
