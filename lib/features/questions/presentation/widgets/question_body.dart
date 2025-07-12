import 'package:flutter/material.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';

class QuestionBody extends StatelessWidget {
  final Question question;
  const QuestionBody({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
      ),
      child: Text(
        question.body ?? '',
        style: AppStyle.styleRegular14(context),
        textAlign: TextAlign.right,
      ),
    );
  }
}
