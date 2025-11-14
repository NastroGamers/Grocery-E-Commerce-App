import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/chat_message_model.dart';
import '../repositories/support_repository.dart';

class SendMessageUseCase {
  final SupportRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessageModel>> call({
    required String channelId,
    required String message,
    List<String>? attachments,
  }) async {
    return await repository.sendMessage(channelId, message, attachments);
  }
}
