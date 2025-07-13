import '../../../domain/entities/question.dart';

sealed class QuestionDetailsState {}

class QuestionDetailsInitial extends QuestionDetailsState {}

class QuestionDetailsLoading extends QuestionDetailsState {}

class QuestionDetailsLoaded extends QuestionDetailsState {
  final Question question;
  final List<String> answers;

  QuestionDetailsLoaded({required this.question, required this.answers});
}

class QuestionDetailsError extends QuestionDetailsState {
  final String message;
  QuestionDetailsError(this.message);
}
