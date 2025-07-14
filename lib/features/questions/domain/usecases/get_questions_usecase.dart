import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<Either<Failure, List<Question>>> call({
    bool fromLocal = false,
    int page = 1,
  }) async {
    return await repository.getQuestions(fromLocal: fromLocal, page: page);
  }

  Future<Either<Failure, List<Question>>> search({required String query}) async {
    return await repository.searchQuestions(query);
  }
}