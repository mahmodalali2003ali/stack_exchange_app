import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/question.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<Question>>> getQuestions({
    bool fromLocal = false,
    int page = 1,
  });
  Future<void> cacheQuestions(List<Question> questions);
  Future<Either<Failure, List<Question>>> searchQuestions(String query);
  Future<void> clearLocalData();
  Future<int> getLocalDataCount();
}
