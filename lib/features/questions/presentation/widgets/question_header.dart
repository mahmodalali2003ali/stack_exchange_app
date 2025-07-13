import 'package:flutter/material.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';

class QuestionHeader extends StatelessWidget {
  final Question question;
  const QuestionHeader({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    question.isAnswered ? Colors.green[50] : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: question.isAnswered ? Colors.green : Colors.grey,
                ),
              ),
              child: Text(
                textAlign: TextAlign.right,
                question.isAnswered ? 'تمت الإجابة' : 'قيد الانتظار',
                style: TextStyle(
                  color: question.isAnswered ? Colors.green : Colors.grey[700],
                ),
              ),
            ),
            const Spacer(),
            Text(
              _formatDate(question.creationDate),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(question.title, style: AppStyle.styleSemiBold16(context)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children:
              question.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue[50],
                      labelStyle: const TextStyle(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 16),
        _buildAuthorInfo(context),
      ],
    );
  }

  Widget _buildAuthorInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue[100],
          child: Text(
            question.ownerName.substring(0, 1),
            style: AppStyle.styleSemiBold16(context),
          )),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.ownerName,
              style: AppStyle.styleSemiBold16(context),
            ),
            Text(
              'سأل في ${_formatDate(question.creationDate)}',
              style: AppStyle.styleRegular12(context).copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
