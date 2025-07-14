
import '../../models/question_model.dart';

abstract class LocalStorage {
  Future<void> init();
  Future<void> insertQuestion(QuestionModel question);
  Future<List<QuestionModel>> getAllQuestions();
  Future<void> clearQuestions();
  Future<int> getQuestionCount();
}