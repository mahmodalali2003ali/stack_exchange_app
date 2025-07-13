import '../../../../core/error/failures.dart';
import '../../../../core/utils/network_checker.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/entities/question.dart';
import '../datasources/local/questions_local_db.dart';
import '../datasources/remote/questions_api_service.dart';
import 'package:dartz/dartz.dart';

import '../models/question_model.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionsApiService apiService;
  final QuestionsLocalDb localDb;

  QuestionRepositoryImpl(this.apiService, this.localDb);

  @override
  Future<Either<Failure, List<Question>>> getQuestions({
    bool fromLocal = false,
    int page = 1,
  }) async {
    try {
      if (fromLocal) {
        // جلب البيانات من التخزين المحلي
        final localQuestions = await localDb.getAllQuestions();
        if (localQuestions.isNotEmpty) {
          return Right(localQuestions);
        }
      }

      final hasConnection = await NetworkChecker.hasConnection();
      if (!hasConnection) {
        final localQuestions = await localDb.getAllQuestions();
        if (localQuestions.isNotEmpty) {
          return Right(localQuestions);
        } else {
          return Left(
            ServerFailuer('لا يوجد اتصال بالإنترنت ولا توجد بيانات محلية'),
          );
        }
      }

      // جلب البيانات من الإنترنت
      final remote = await apiService.fetchQuestions(page);

      // حفظ البيانات في التخزين المحلي
      await localDb.clearQuestions();
      for (var question in remote) {
        await localDb.insertQuestion(question);
      }

      return Right(remote);
    } catch (e) {
      if (!fromLocal) {
        try {
          final localQuestions = await localDb.getAllQuestions();
          if (localQuestions.isNotEmpty) {
            return Right(localQuestions);
          }
        } catch (localError) {
          return Left(
            ServerFailuer(
              'لا توجد بيانات محلية متاحة: ${localError.toString()}',
            ),
          );
        }
      }
      return Left(ServerFailuer(e.toString()));
    }
  }

  Future<List<Question>> getLocalQuestions() async {
    return await localDb.getAllQuestions();
  }

  Future<QuestionModel> getRemoteQuestions({int page = 1}) async {
    return await apiService.fetchQuestionBody(page);
  }

  @override
  Future<void> cacheQuestions(List<Question> questions) async {
    await localDb.clearQuestions();
    for (var question in questions) {
      if (question is QuestionModel) {
        await localDb.insertQuestion(question);
      }
    }
  }

  @override
  Future<void> clearLocalData() async {
    await localDb.clearQuestions();
  }

  @override
  Future<int> getLocalDataCount() async {
    final questions = await localDb.getAllQuestions();
    return questions.length;
  }

  @override
  Future<Either<Failure, List<Question>>> searchQuestions(String query) async {
    try {
      final localQuestions = await localDb.getAllQuestions();
      final localResults =
          localQuestions.where((q) {
            return q.title.toLowerCase().contains(query.toLowerCase()) ||
                q.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                ) ||
                (q.ownerName.toLowerCase().contains(query.toLowerCase()));
          }).toList();

      if (localResults.isNotEmpty) {
        return Right(localResults);
      }

      final remoteResults = await apiService.searchQuestions(query);
      for (var question in remoteResults) {
        await localDb.insertQuestion(
          QuestionModel.fromJson(question as Map<String, dynamic>),
        );
      }
      return Right(remoteResults);
    } catch (e) {
      return Left(ServerFailuer(e.toString()));
    }
  }
}
