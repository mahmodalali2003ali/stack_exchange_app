import 'package:flutter/material.dart';
import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';
import '../widgets/answer_card.dart';
import '../widgets/question_header.dart';
import '../widgets/question_body.dart';

class QuestionDetailsPage extends StatelessWidget {
  final Question question;
  const QuestionDetailsPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          '📖 تفاصيل السؤال',
          style: AppStyle.styleSemiBold20(context),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionHeader(question: question),
                  const SizedBox(height: 12),
                  QuestionBody(question: question),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildAnswersSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswersSection(BuildContext context) {
    final answers = _generateSampleAnswers();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('💬 الإجابات', style: AppStyle.styleSemiBold20(context)),
        const SizedBox(height: 12),
        if (answers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'لا توجد إجابات حتى الآن.',
              style: AppStyle.styleRegular14(context),
            ),
          )
        else
          ...answers.asMap().entries.map(
            (entry) => AnswerCard(
              answerNumber: entry.key + 1,
              answerText: entry.value,
            ),
          ),
      ],
    );
  }

  List<String> _generateSampleAnswers() {
    return [
      '''يمكنك دعم اللغة العربية باستخدام:
```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: MaterialApp(...)
)
```''',
      '''استخدم `flutter_localizations` لتفعيل دعم اللغات في Flutter:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
```''',
    ];
  }
}
