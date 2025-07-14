part of 'question_cubit.dart';

sealed class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {}

class QuestionLoading extends QuestionState {}

class QuestionSearching extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<Question> questions;

  const QuestionLoaded(this.questions);

  @override
  List<Object> get props => [questions];
}

class QuestionLoadingMore extends QuestionState {
  final List<Question> questions;

  const QuestionLoadingMore(this.questions);

  @override
  List<Object> get props => [questions];
}

class QuestionEmpty extends QuestionState {}

class QuestionError extends QuestionState {
  final String message;

  const QuestionError(this.message);

  @override
  List<Object> get props => [message];
}