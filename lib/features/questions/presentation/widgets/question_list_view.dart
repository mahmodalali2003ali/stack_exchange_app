import 'package:flutter/material.dart';
import 'dart:developer';
import '../../domain/entities/question.dart';
import '../widgets/question_card.dart';

class QuestionListView extends StatefulWidget {
  final List<Question> questions;
  final VoidCallback onLoadMore;

  const QuestionListView({
    super.key,
    required this.questions,
    required this.onLoadMore,
  });

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore) {
        setState(() => _isLoadingMore = true);
        widget.onLoadMore();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _isLoadingMore = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('📱 QuestionListView: بناء قائمة بـ ${widget.questions.length} سؤال');
    if (widget.questions.isEmpty) {
      return const Center(child: Text('لا توجد أسئلة لعرضها'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: widget.questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              log('📱 QuestionListView: بناء السؤال رقم ${index + 1} من ${widget.questions.length}: ${widget.questions[index].title}');
             
              final globalIndex = index;
              return QuestionCard(
                question: widget.questions[index],
                index: globalIndex, 
              );
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