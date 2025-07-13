import 'dart:developer';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_client.dart';
import '../../../domain/entities/question.dart';
import '../../models/question_model.dart';

class QuestionsApiService {
  final DioClient dioClient;
  QuestionsApiService(this.dioClient);

  Future<List<QuestionModel>> fetchQuestions(int page) async {
    print('📡 QuestionsApiService: جلب الأسئلة من الصفحة $page');
    final response = await dioClient.get(
      ApiConstants.questionsEndpoint,
      queryParameters: {
        'page': page,
        'pagesize': 5,
        'order': 'desc',
        'sort': 'activity',
        'site': ApiConstants.site,
      },
    );
    print('📡 QuestionsApiService: تم استلام الرد من API');
    log('📦 Response: ${response.data}');

    final items = response.data['items'] as List;
    print('📡 QuestionsApiService: عدد العناصر المستلمة: ${items.length}');

    final questions =
        items.map((e) {
          try {
            final question = QuestionModel.fromJson(e);
            print('📡 QuestionsApiService: تم تحويل السؤال: ${question.title}');
            return question;
          } catch (error) {
            print('📡 QuestionsApiService: خطأ في تحويل السؤال: $error');
            print('📡 QuestionsApiService: البيانات: $e');
            rethrow;
          }
        }).toList();

    print('📡 QuestionsApiService: تم تحويل ${questions.length} سؤال بنجاح');
    return questions;
  }

  Future<QuestionModel> fetchQuestionBody(int questionId) async {
    final response = await dioClient.get(
      '/questions/$questionId',
      queryParameters: {'site': 'stackoverflow', 'filter': 'withbody'},
    );

    final item = (response.data['items'] as List).first;
    return QuestionModel.fromJson(item);
  }

  Future<List<String>> fetchAnswers(int questionId) async {
    final response = await dioClient.get(
      '/questions/$questionId/answers',
      queryParameters: {
        'site': 'stackoverflow',
        'order': 'desc',
        'sort': 'votes',
        'filter': 'withbody',
      },
    );

    return (response.data['items'] as List)
        .map((e) => e['body'] as String)
        .toList();
  }

  Future<List<QuestionModel>> searchQuestions(String query) async {
    final response = await dioClient.get(
      ApiConstants.search,
      queryParameters: {
        'intitle': query,
        'site': ApiConstants.site,
        'order': 'desc',
        'sort': 'relevance',
      },
    );

    return (response.data['items'] as List)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
  }
}
