import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';
import 'question_card.dart';

class QuestionListView extends StatefulWidget {
  final List<Question> questions;
  final VoidCallback? onLoadMore;

  const QuestionListView({super.key, required this.questions, this.onLoadMore});

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (widget.onLoadMore == null) return;

    setState(() => _isLoadingMore = true);
    widget.onLoadMore!();
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    print('📱 QuestionListView: بناء قائمة بـ ${widget.questions.length} سؤال');
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: widget.questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              print(
                '📱 QuestionListView: بناء السؤال رقم $index: ${widget.questions[index].title}',
              );
              return QuestionCard(question: widget.questions[index]);
            },
          ),
        ),
        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
