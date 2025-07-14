import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/question.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<Question>>> getQuestions({
    bool fromLocal = false,
    int page = 1,
  });
  Future<Either<Failure, Question>> getRemoteQuestionBody({
    required int questionId,
  });
  Future<void> cacheQuestions(List<Question> questions);
  Future<void> clearLocalData();
  Future<int> getLocalDataCount();
  Future<Either<Failure, List<Question>>> searchQuestions(String query);
}