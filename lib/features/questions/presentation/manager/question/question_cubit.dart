// question_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/question.dart';
import '../../../domain/usecases/get_questions_usecase.dart';

part 'question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final GetQuestionsUseCase useCase;

  final List<Question> _allQuestions = [];
  List<Question> _filteredQuestions = [];
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;
  bool isLastFetchFromLocal = false;

  String _currentSearchQuery = '';

  QuestionCubit(this.useCase) : super(QuestionInitial());

  Future<void> fetchQuestions({
    bool isRefresh = false,
    bool fromLocal = false,
    
  }) async {
    if (_isFetching || (!_hasMore && !isRefresh)) return;

    _isFetching = true;

    if (isRefresh) {
      emit(QuestionLoading());
      _currentPage = 1;
      _hasMore = true;
      _allQuestions.clear();
      _filteredQuestions.clear();
      _currentSearchQuery = '';
    } else {
      emit(QuestionLoadingMore(
        _currentSearchQuery.isEmpty ? _allQuestions : _filteredQuestions,
      ));
    }

    final result = await useCase(fromLocal: fromLocal, page: _currentPage);

    result.fold((failure) => emit(QuestionError(failure.message)), (questions) {
      if (questions.length < 10) _hasMore = false;
      _allQuestions.addAll(questions);

      if (_currentSearchQuery.isNotEmpty) {
        _performSearch(_currentSearchQuery);
      } else {
        _filteredQuestions = List.from(_allQuestions);
        isLastFetchFromLocal = fromLocal;

        emit(QuestionLoaded(_filteredQuestions));
      }
      _currentPage++;
    });
    _isFetching = false;
  }

  void search(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      resetSearch();
      return;
    }
    if (trimmedQuery == _currentSearchQuery) return;

    _currentSearchQuery = trimmedQuery;
    _performSearch(trimmedQuery);
  }

  void _performSearch(String query) async {
    try {
      final localResults = _allQuestions.where((q) {
        return q.title.toLowerCase().contains(query.toLowerCase()) ||
            q.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
            q.ownerName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (localResults.isNotEmpty) {
        _filteredQuestions = localResults;
        emit(QuestionLoaded(_filteredQuestions));
      } else {
        emit(QuestionSearching());
        final result = await useCase.searchQuestions(query);
        result.fold((failure) => emit(QuestionError(failure.message)), (questions) {
          _filteredQuestions = questions;
          emit(questions.isEmpty ? QuestionEmpty() : QuestionLoaded(questions));
        });
      }
    } catch (e) {
      emit(QuestionError('Search error: ${e.toString()}'));
    }
  }

  void resetSearch() {
    _currentSearchQuery = '';
    _filteredQuestions = List.from(_allQuestions);
    emit(QuestionLoaded(_filteredQuestions));
  }

  Future<void> clearLocalData() async {
    try {
      await useCase.clearLocalData();
      _allQuestions.clear();
      _filteredQuestions.clear();
      _currentPage = 1;
      _hasMore = true;
      emit(QuestionEmpty());
    } catch (e) {
      emit(QuestionError('فشل في مسح البيانات المحلية: ${e.toString()}'));
    }
  }

  Future<int> getLocalDataCount() async {
    try {
      return await useCase.getLocalDataCount();
    } catch (_) {
      return 0;
    }
  }
}
