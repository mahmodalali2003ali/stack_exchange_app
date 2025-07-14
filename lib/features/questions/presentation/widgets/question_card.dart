import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';
import '../views/question_details_page.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index; // إضافة الرقم التسلسلي كمعامل

  const QuestionCard({
    super.key,
    required this.question,
    required this.index, // يجب تمرير الرقم التسلسلي عند استخدام البطاقة
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionDetailsPage(question: question),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 8),
              _buildTitle(context),
              const SizedBox(height: 12),
              _buildTags(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${index + 1}',
            style: AppStyle.styleRegular12(context)
                .copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        if (question.isAnswered)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'تمت الإجابة',
              style: AppStyle.styleRegular12(context)
                  .copyWith(color: AppColors.primaryColor),
            ),
          ),
        const Spacer(),
        Text(
          DateFormat('yyyy/MM/dd - hh:mm a').format(question.creationDate),
          style: AppStyle.styleRegular12(context).copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      question.title,
      style: AppStyle.styleSemiBold16(context),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: question.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: AppStyle.styleRegular12(context)
                .copyWith(color: AppColors.primaryColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // المستخدم
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey[200],
                child: Text(
                  question.ownerName.substring(0, 1),
                  style: AppStyle.styleRegular12(context),
                ),
              ),
              const SizedBox(width: 8),
              Text(question.ownerName, style: AppStyle.styleRegular12(context)),
            ],
          ),
        ),
        // الإحصائيات
        Row(
          children: [
            _buildStatItem(Icons.thumbs_up_down, question.score),
            const SizedBox(width: 12),
            _buildStatItem(
              Icons.comment,
              question.answerCount,
              isAnswered: question.isAnswered,
            ),
            const SizedBox(width: 12),
            _buildStatItem(Icons.remove_red_eye, question.viewCount),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, int count, {bool isAnswered = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isAnswered ? AppColors.primaryColor : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            color: isAnswered ? AppColors.primaryColor : Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}