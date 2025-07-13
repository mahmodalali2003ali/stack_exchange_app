// questions_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/question.dart';
import '../manager/question/question_cubit.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/question_list_view.dart';
import '../widgets/search_and_filterBar.dart';
import '../widgets/skeleton_question_card.dart';

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

  @override
  void initState() {
    super.initState();
    _questionCubit = context.read<QuestionCubit>();
    _loadInitialData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadInitialData() async {
    print('📱 QuestionsPage: بدء تحميل البيانات من الإنترنت أولاً');
    // محاولة جلب البيانات من الإنترنت أولًا
    await _questionCubit.fetchQuestions(isRefresh: true);

    // ثم تحديث عدد البيانات المحلية (إن وُجدت)
    _updateLocalDataCount();
  }

  Future<void> _updateLocalDataCount() async {
    final count = await _questionCubit.getLocalDataCount();
    setState(() {
      _localDataCount = count;
    });
  }

  void _showLocalDataInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحميل البيانات من التخزين المحلي'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _clearLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('تأكيد المسح'),
            content: Text('هل تريد مسح جميع البيانات المحلية؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('مسح'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await _questionCubit.clearLocalData();
      _updateLocalDataCount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
            Text('أسئلة Stack Overflow'),
            if (_localDataCount > 0)
              Text(
                'البيانات المحلية: $_localDataCount',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () => _questionCubit.fetchQuestions(fromLocal: true),
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
          Expanded(
            child: BlocConsumer<QuestionCubit, QuestionState>(
              listener: (context, state) {
                print(
                  '📱 QuestionsPage: تغيير الحالة إلى: ${state.runtimeType}',
                );
                if (state is QuestionError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is QuestionLoaded) {
                  if (_questionCubit.isLastFetchFromLocal) {
                    _showLocalDataInfo(); 
                  }
                }
              },
              builder: (context, state) {
              
                if (state is QuestionLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder:
                        (_, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const SkeletonQuestionCard(),
                        ),
                  );
                } else if (state is QuestionSearching) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is QuestionEmpty) {
                  return EmptyStateWidget(
                    onRetry:
                        () => _questionCubit.fetchQuestions(isRefresh: true),
                  );
                } else if (state is QuestionLoaded) {
                  final sorted = _applySort(state.questions);
                  print(
                    '📱 QuestionsPage: بناء قائمة بـ ${state.questions.length} سؤال',
                  );
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: QuestionListView(
                      questions: sorted,
                      onLoadMore: () => _questionCubit.fetchQuestions(),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
