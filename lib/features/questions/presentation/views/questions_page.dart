import 'package:flutter/material.dart';

import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/question_list_view.dart';
import '../widgets/search_and_filterBar.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Question> _filteredQuestions = [];
  bool _isLoading = false;
  String _selectedFilter = 'الأحدث';

  final List<Question> _sampleQuestions = List.generate(
    15,
    (i) => Question(
      id: i,
      title: 'كيف يمكنني حل مشكلة ${i + 1} في Flutter؟',
      body: 'وصف تفصيلي لمشكلة ${i + 1} وحاولت الحلول التالية...',
      score: (i * 3) % 15,
      ownerName: ['أحمد', 'محمد', 'علي', 'فاطمة'][i % 4],
      ownerProfileImage: null,
      link: 'https://stackoverflow.com/q/$i',
      tags: ['flutter', 'dart', 'android', 'ios', 'state'][i % 5].split(' '),
      creationDate: DateTime.now().subtract(Duration(days: i % 3, hours: i)),
      answerCount: i % 4,
      viewCount: 50 + i * 10,
      isAnswered: i % 3 == 0,
    ),
  );

  @override
  void initState() {
    super.initState();
    _filteredQuestions = _sampleQuestions;
    _searchController.addListener(_filterQuestions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterQuestions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredQuestions =
          _sampleQuestions.where((question) {
            return question.title.toLowerCase().contains(query) ||
                question.tags.any((tag) => tag.toLowerCase().contains(query)) ||
                question.ownerName.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      switch (filter) {
        case 'الأحدث':
          _filteredQuestions.sort(
            (a, b) => b.creationDate.compareTo(a.creationDate),
          );
          break;
        case 'الأكثر تصويتاً':
          _filteredQuestions.sort((a, b) => b.score.compareTo(a.score));
          break;
        case 'الأكثر إجابة':
          _filteredQuestions.sort(
            (a, b) => b.answerCount.compareTo(a.answerCount),
          );
          break;
        case 'الأكثر مشاهدة':
          _filteredQuestions.sort((a, b) => b.viewCount.compareTo(a.viewCount));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'أسئلة Stack Overflow',
          style: AppStyle.styleSemiBold20(context),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: Column(
        children: [
          SearchAndFilterBar(
            controller: _searchController,
            selectedFilter: _selectedFilter,
            onFilterChanged: _applyFilter,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppColors.primaryColor,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredQuestions.isEmpty
                      ? const EmptyStateWidget()
                      : QuestionListView(questions: _filteredQuestions),
            ),
          ),
        ],
      ),
    );
  }
}
