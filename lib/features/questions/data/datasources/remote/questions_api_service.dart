import 'dart:developer';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_client.dart';
import '../../models/question_model.dart';

class QuestionsApiService {
  final DioClient dioClient;

  QuestionsApiService(this.dioClient);

  Future<List<QuestionModel>> fetchQuestions(int page) async {
    final response = await dioClient.get(
      ApiConstants.questionsEndpoint,
      queryParameters: {
        'page': page,
        'pagesize': 10,
        'order': 'desc',
        'sort': 'activity',
        'site': ApiConstants.site,
      },
    );
    log('📋 QuestionsApiService: استجابة الـ API: ${response.data}');
    final items = response.data['items'] as List;
    final questions = items.map((e) {
      try {
        return QuestionModel.fromJson(e);
      } catch (error) {
        log('📋 QuestionsApiService: خطأ في تحليل السؤال: $error');
        rethrow;
      }
    }).toList();
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

  Future<List<String>> fetchComments(int questionId) async {
    final response = await dioClient.get(
      '/questions/$questionId/comments',
      queryParameters: {
        'site': 'stackoverflow',
        'order': 'desc',
        'sort': 'creation',
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