import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/faq_model.dart';
import '../repositories/support_repository.dart';

class GetFAQsUseCase {
  final SupportRepository repository;

  GetFAQsUseCase(this.repository);

  Future<Either<Failure, List<FAQModel>>> call({
    String? category,
    String? searchQuery,
  }) async {
    return await repository.getFAQs(
      category: category,
      searchQuery: searchQuery,
    );
  }
}
