import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';
import 'question_card.dart';

class QuestionListView extends StatelessWidget {
  final List<Question> questions;

  const QuestionListView({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return QuestionCard(
          question: questions[index],
          key: ValueKey(questions[index].id),
        );
      },
    );
  }
}
