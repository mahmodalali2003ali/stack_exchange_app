import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/local/questions_local_db.dart';
import '../datasources/remote/questions_api_service.dart';
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
        final localQuestions = await localDb.getAllQuestions();
        log('📋 QuestionRepositoryImpl: جلب ${localQuestions.length} سؤال من التخزين المحلي');
        if (localQuestions.isNotEmpty) {
          return Right(localQuestions);
        }
      }

      final hasConnection = await NetworkChecker.hasConnection();
      log('📋 QuestionRepositoryImpl: حالة الاتصال: $hasConnection');

      if (!hasConnection) {
        final localQuestions = await localDb.getAllQuestions();
        log('📋 QuestionRepositoryImpl: جلب ${localQuestions.length} سؤال من التخزين المحلي (بدون اتصال)');
        if (localQuestions.isNotEmpty) {
          return Right(localQuestions);
        } else {
          return Left(
            ServerFailuer('لا يوجد اتصال بالإنترنت ولا توجد بيانات محلية'),
          );
        }
      }

      final remote = await apiService.fetchQuestions(page);
      log('📋 QuestionRepositoryImpl: تم جلب ${remote.length} سؤال من الـ API');

      try {
        await localDb.clearQuestions();
        for (var question in remote) {
          await localDb.insertQuestion(question);
        }
        log('📋 QuestionRepositoryImpl: تم تخزين ${remote.length} سؤال في التخزين المحلي');
      } catch (e) {
        log('📋 QuestionRepositoryImpl: فشل تخزين البيانات محليًا: $e');
      }

      return Right(remote);
    } catch (e) {
      log('📋 QuestionRepositoryImpl: خطأ: $e');
      if (!fromLocal) {
        try {
          final localQuestions = await localDb.getAllQuestions();
          log('📋 QuestionRepositoryImpl: جلب ${localQuestions.length} سؤال من التخزين المحلي بعد الخطأ');
          if (localQuestions.isNotEmpty) {
            return Right(localQuestions);
          }
        } catch (localError) {
          log('📋 QuestionRepositoryImpl: خطأ في جلب البيانات المحلية: $localError');
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

  @override
  Future<Either<Failure, Question>> getRemoteQuestionBody({
    required int questionId,
  }) async {
    try {
      final question = await apiService.fetchQuestionBody(questionId);
      return Right(question);
    } catch (e) {
      return Left(ServerFailuer(e.toString()));
    }
  }

  @override
  Future<void> cacheQuestions(List<Question> questions) async {
    try {
      await localDb.clearQuestions();
      for (var question in questions) {
        if (question is QuestionModel) {
          await localDb.insertQuestion(question);
        }
      }
      log('📋 QuestionRepositoryImpl: تم تخزين ${questions.length} سؤال في التخزين المحلي');
    } catch (e) {
      log('📋 QuestionRepositoryImpl: فشل في التخزين المحلي: $e');
    }
  }

  @override
  Future<void> clearLocalData() async {
    try {
      await localDb.clearQuestions();
      log('📋 QuestionRepositoryImpl: تم مسح البيانات المحلية');
    } catch (e) {
      log('📋 QuestionRepositoryImpl: فشل في مسح البيانات المحلية: $e');
    }
  }

  @override
  Future<int> getLocalDataCount() async {
    try {
      return await localDb.getQuestionCount();
    } catch (e) {
      log('📋 QuestionRepositoryImpl: خطأ في جلب عدد الأسئلة المحلية: $e');
      return 0;
    }
  }

  @override
  Future<Either<Failure, List<Question>>> searchQuestions(String query) async {
    try {
      final localQuestions = await localDb.getAllQuestions();
      final localResults = localQuestions.where((q) {
        return q.title.toLowerCase().contains(query.toLowerCase()) ||
            q.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
            q.ownerName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (localResults.isNotEmpty) {
        log('📋 QuestionRepositoryImpl: تم العثور على ${localResults.length} نتيجة محلية');
        return Right(localResults);
      }

      final remoteResults = await apiService.searchQuestions(query);
      try {
        for (var question in remoteResults) {
          await localDb.insertQuestion(question);
        }
        log('📋 QuestionRepositoryImpl: تم تخزين ${remoteResults.length} نتيجة بحث في التخزين المحلي');
      } catch (e) {
        log('📋 QuestionRepositoryImpl: فشل في تخزين نتائج البحث محليًا: $e');
      }
      return Right(remoteResults);
    } catch (e) {
      log('📋 QuestionRepositoryImpl: خطأ في البحث: $e');
      return Left(ServerFailuer(e.toString()));
    }
  }
}