
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/dio_client.dart';
import '../../../data/datasources/remote/questions_api_service.dart';
import 'question_details_state.dart';


class QuestionDetailsCubit extends Cubit<QuestionDetailsState> {
  QuestionDetailsCubit(QuestionsApiService apiService) : super(QuestionDetailsInitial());
    final QuestionsApiService apiService = QuestionsApiService(DioClient());
Future<void> fetchQuestionDetails(int questionId) async {
    try {
      emit(QuestionDetailsLoading());
      final question = await apiService.fetchQuestionBody(questionId);
      final answers = await apiService.fetchAnswers(questionId);
      emit(QuestionDetailsLoaded(question: question, answers: answers));
    } catch (e) {
      emit(QuestionDetailsError(e.toString()));
    }
  }
}
