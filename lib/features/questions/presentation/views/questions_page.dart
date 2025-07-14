// ignore_for_file: unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import '../../../../core/utils/service_locator.dart';
import '../../data/datasources/local/local_storage.dart';
import '../../data/datasources/local/questions_local_db.dart';
import '../../domain/entities/question.dart';
import '../manager/question/question_cubit.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/question_list_view.dart';
import '../widgets/search_and_filterBar.dart';
import '../widgets/skeleton_question_card.dart';
import '../../data/datasources/local/hive_storage.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final QuestionCubit _questionCubit;
  String _selectedFilter = 'الأحدث';
  bool _isSearchActive = false;
  int _localDataCount = 0;
  String _storageType = kIsWeb ? 'Hive' : 'SQLite';

  @override
  void initState() {
    super.initState();
    _questionCubit = context.read<QuestionCubit>();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadInitialData() async {
    log('📱 QuestionsPage: بدء تحميل البيانات من الإنترنت أولاً');
    await _questionCubit.fetchQuestions(isRefresh: true);
    _updateLocalDataCount();
  }

  Future<void> _updateLocalDataCount() async {
    final count = await _questionCubit.getLocalDataCount();
    setState(() {
      _localDataCount = count;
    });
  }

  Future<void> _switchStorage(String newStorage) async {
    if (newStorage == _storageType) return;
    if (kIsWeb && newStorage == 'SQLite') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SQLite غير مدعوم على الويب، يرجى استخدام Hive'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final localStorage = newStorage == 'Hive' ? HiveStorage() : SqliteStorage();
    await localStorage.init();
    getIt.unregister<LocalStorage>();
    getIt.registerLazySingleton<LocalStorage>(() => localStorage);

    await _questionCubit.clearLocalData();
    await _questionCubit.fetchQuestions(isRefresh: true);
    setState(() {
      _storageType = newStorage;
    });
    _updateLocalDataCount();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم التبديل إلى التخزين: $_storageType'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showLocalDataInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحميل البيانات من التخزين المحلي'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _clearLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد المسح'),
        content: const Text('هل تريد مسح جميع البيانات المحلية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('مسح'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _questionCubit.clearLocalData();
      _updateLocalDataCount();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم مسح البيانات المحلية'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() => _isSearchActive = query.isNotEmpty);
    if (query.isEmpty) {
      _questionCubit.resetSearch();
    } else if (query.length > 2) {
      _questionCubit.search(query);
    }
  }

  void _applyFilter(String filter) {
    if (_selectedFilter == filter) return;
    setState(() => _selectedFilter = filter);
  }

  Future<void> _refreshData() async {
    await _questionCubit.fetchQuestions(isRefresh: true);
    if (_searchController.text.isNotEmpty) {
      _questionCubit.search(_searchController.text);
    }
  }

  List<Question> _applySort(List<Question> questions) {
    final sorted = [...questions];
    switch (_selectedFilter) {
      case 'الأكثر تصويتاً':
        sorted.sort((a, b) => b.score.compareTo(a.score));
        break;
      case 'الأكثر إجابة':
        sorted.sort((a, b) => b.answerCount.compareTo(a.answerCount));
        break;
      case 'الأكثر مشاهدة':
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
      default:
        sorted.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    }
    return sorted;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أسئلة Stack Overflow'),
            
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _switchStorage,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'SQLite', child: Text('SQLite')),
              const PopupMenuItem(value: 'Hive', child: Text('Hive')),
            ],
            child: const Icon(Icons.storage),
          ),
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () async {
              await _questionCubit.fetchQuestions(
                fromLocal: true,
                isRefresh: true,
              );
              _updateLocalDataCount();
            },
            tooltip: 'تحميل البيانات المحلية',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearLocalData,
            tooltip: 'مسح البيانات المحلية',
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: Column(
        children: [
          SearchAndFilterBar(
            controller: _searchController,
            selectedFilter: _selectedFilter,
            onFilterChanged: _applyFilter,
            onSearchTap: () => setState(() => _isSearchActive = false),
          ),
          if (_questionCubit.isLastFetchFromLocal)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'عرض البيانات من التخزين المحلي (غير متصل)',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          Expanded(
            child: BlocConsumer<QuestionCubit, QuestionState>(
              listener: (context, state) {
                log('📱 QuestionsPage: الحالة الحالية: $state');
                if (state is QuestionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is QuestionLoaded) {
                  if (_questionCubit.isLastFetchFromLocal) {
                    _showLocalDataInfo();
                  }
                }
              },
              builder: (context, state) {
                if (state is QuestionInitial) {
                  _questionCubit.fetchQuestions(isRefresh: true);
                  return const Center(child: CircularProgressIndicator());
                } else if (state is QuestionLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, index) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SkeletonQuestionCard(),
                    ),
                  );
                } else if (state is QuestionSearching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is QuestionEmpty) {
                  return EmptyStateWidget(
                    onRetry: () => _questionCubit.fetchQuestions(isRefresh: true),
                  );
                } else if (state is QuestionLoaded || state is QuestionLoadingMore) {
                  final questions = state is QuestionLoaded
                      ? state.questions
                      : (state as QuestionLoadingMore).questions;
                  final sorted = _applySort(questions);
                  log('📱 QuestionsPage: عرض ${sorted.length} سؤال');
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: QuestionListView(
                      questions: sorted,
                      onLoadMore: () => _questionCubit.fetchQuestions(),
                    ),
                  );
                }
                return const Center(child: Text('حالة غير متوقعة'));
              },
            ),
          ),
        ],
      ),
    );
  }
}