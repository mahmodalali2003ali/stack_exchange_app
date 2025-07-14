import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';
import '../../../domain/entities/question.dart';
import '../../../domain/usecases/get_questions_usecase.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetQuestionsUseCase useCase;
  final List<Question> _allQuestions = [];
  List<Question> _filteredQuestions = [];
  int _currentPage = 1;
  bool _hasMore = true;
  String _currentSearchQuery = '';
  bool isLastFetchFromLocal = false;

  QuestionCubit(this.useCase) : super(QuestionInitial());

  Future<void> fetchQuestions({bool isRefresh = false, bool fromLocal = false}) async {
    if (!_hasMore && !isRefresh) return;
    if (isRefresh) {
      _currentPage = 1;
      _allQuestions.clear();
      _filteredQuestions.clear();
      _hasMore = true;
    }

    emit(QuestionLoading());
    final result = await useCase.call(
      page: _currentPage,
      fromLocal: fromLocal,
    );

    result.fold(
      (failure) {
        log('📋 QuestionCubit: خطأ: ${failure.message}');
        emit(QuestionError(failure.message));
      },
      (questions) {
        log('📋 QuestionCubit: تم جلب ${questions.length} سؤال');
        if (questions.isEmpty && _allQuestions.isEmpty) {
          emit(QuestionEmpty());
        } else {
          if (questions.isEmpty) _hasMore = false;
          _allQuestions.addAll(questions);
          isLastFetchFromLocal = fromLocal;
          log('📋 QuestionCubit: إجمالي الأسئلة في _allQuestions: ${_allQuestions.length}');
          if (_currentSearchQuery.isNotEmpty) {
            _performSearch(_currentSearchQuery);
          } else {
            _filteredQuestions = List.from(_allQuestions);
            log('📋 QuestionCubit: إجمالي الأسئلة في _filteredQuestions: ${_filteredQuestions.length}');
            emit(QuestionLoaded(_filteredQuestions));
          }
          _currentPage++;
        }
      },
    );
  }

  Future<void> search(String query) async {
    _currentSearchQuery = query;
    if (query.isEmpty) {
      _filteredQuestions = List.from(_allQuestions);
      emit(QuestionLoaded(_filteredQuestions));
      return;
    }

    emit(QuestionSearching());
    final result = await useCase.search(query: query);
    result.fold(
      (failure) => emit(QuestionError(failure.message)),
      (questions) {
        _filteredQuestions = questions;
        if (_filteredQuestions.isEmpty) {
          emit(QuestionEmpty());
        } else {
          emit(QuestionLoaded(_filteredQuestions));
        }
      },
    );
  }

  void resetSearch() {
    _currentSearchQuery = '';
    _filteredQuestions = List.from(_allQuestions);
    if (_filteredQuestions.isEmpty) {
      emit(QuestionEmpty());
    } else {
      emit(QuestionLoaded(_filteredQuestions));
    }
  }

  Future<void> clearLocalData() async {
    try {
      await useCase.repository.clearLocalData();
      _allQuestions.clear();
      _filteredQuestions.clear();
      _currentPage = 1;
      _hasMore = true;
      emit(QuestionEmpty());
    } catch (e) {
      emit(QuestionError('فشل في مسح البيانات المحلية: $e'));
    }
  }

  Future<int> getLocalDataCount() async {
    try {
      return await useCase.repository.getLocalDataCount();
    } catch (e) {
      log('📋 QuestionCubit: خطأ في جلب عدد الأسئلة المحلية: $e');
      return 0;
    }
  }

  void _performSearch(String query) {
    _filteredQuestions = _allQuestions.where((q) {
      return q.title.toLowerCase().contains(query.toLowerCase()) ||
          q.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
          q.ownerName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    if (_filteredQuestions.isEmpty) {
      emit(QuestionEmpty());
    } else {
      emit(QuestionLoaded(_filteredQuestions));
    }
  }
}