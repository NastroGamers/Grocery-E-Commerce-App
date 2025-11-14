import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_datasource.dart';
import '../models/chat_message_model.dart';
import '../models/support_ticket_model.dart';
import '../models/faq_model.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory(
    String channelId,
    int page,
  ) async {
    try {
      final messages = await remoteDataSource.getChatHistory(channelId, page);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage(
    String channelId,
    String message,
    List<String>? attachments,
  ) async {
    try {
      if (message.trim().isEmpty || message.length > 1000) {
        return Left(ValidationFailure(message: 'Message must be between 1-1000 characters'));
      }

      final sentMessage = await remoteDataSource.sendMessage(
        channelId,
        message,
        attachments,
      );
      return Right(sentMessage);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(
    String channelId,
    List<String> messageIds,
  ) async {
    try {
      await remoteDataSource.markMessagesAsRead(channelId, messageIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportTicketModel>> createSupportTicket({
    required String subject,
    required String description,
    required String category,
    required String priority,
    String? orderId,
    List<String>? attachments,
  }) async {
    try {
      if (subject.trim().isEmpty || subject.length < 5) {
        return Left(ValidationFailure(message: 'Subject must be at least 5 characters'));
      }

      if (description.trim().isEmpty || description.length < 20) {
        return Left(ValidationFailure(message: 'Description must be at least 20 characters'));
      }

      final ticket = await remoteDataSource.createSupportTicket(
        subject: subject,
        description: description,
        category: category,
        priority: priority,
        orderId: orderId,
        attachments: attachments,
      );
      return Right(ticket);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportTicketModel>>> getTickets({
    String? status,
    int page = 1,
  }) async {
    try {
      final tickets = await remoteDataSource.getTickets(status: status, page: page);
      return Right(tickets);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportTicketModel>> getTicketDetails(String ticketId) async {
    try {
      final ticket = await remoteDataSource.getTicketDetails(ticketId);
      return Right(ticket);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeTicket(String ticketId) async {
    try {
      await remoteDataSource.closeTicket(ticketId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FAQModel>>> getFAQs({
    String? category,
    String? searchQuery,
  }) async {
    try {
      final faqs = await remoteDataSource.getFAQs(
        category: category,
        searchQuery: searchQuery,
      );
      return Right(faqs);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markFAQHelpful(String faqId, bool isHelpful) async {
    try {
      await remoteDataSource.markFAQHelpful(faqId, isHelpful);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
