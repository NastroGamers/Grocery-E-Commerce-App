import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/support_ticket_model.dart';
import '../repositories/support_repository.dart';

class CreateTicketUseCase {
  final SupportRepository repository;

  CreateTicketUseCase(this.repository);

  Future<Either<Failure, SupportTicketModel>> call({
    required String subject,
    required String description,
    required String category,
    required String priority,
    String? orderId,
    List<String>? attachments,
  }) async {
    return await repository.createSupportTicket(
      subject: subject,
      description: description,
      category: category,
      priority: priority,
      orderId: orderId,
      attachments: attachments,
    );
  }
}
