import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/question_repository.dart';
import '../entities/question.dart';

class GetQuestionsUseCase {
  final QuestionRepository repository;

  GetQuestionsUseCase(this.repository);

  Future<Either<Failure, List<Question>>> call({
    bool fromLocal = false,
    int page = 1,
  }) {
    return repository.getQuestions(fromLocal: fromLocal, page: page);
  }

  Future<void> cacheQuestions(List<Question> questions) {
    return repository.cacheQuestions(questions);
  }

  Future<Either<Failure, List<Question>>> searchQuestions(String query) async {
    return await repository.searchQuestions(query);
  }

  Future<void> clearLocalData() async {
    return await repository.clearLocalData();
  }

  Future<int> getLocalDataCount() async {
    return await repository.getLocalDataCount();
  }
}
