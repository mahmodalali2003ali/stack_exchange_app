import 'package:flutter/material.dart';
import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';

class AnswerCard extends StatelessWidget {
  final int answerNumber;
  final String answerText;
  const AnswerCard({
    super.key,
    required this.answerNumber,
    required this.answerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📝 إجابة رقم $answerNumber',
            style: AppStyle.styleSemiBold16(
              context,
            ).copyWith(color: AppColors.primaryColor),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          ..._parseAnswerText(answerText, context),
        ],
      ),
    );
  }

  List<Widget> _parseAnswerText(String text, BuildContext context) {
    final lines = text.trim().split('\n');
    List<Widget> widgets = [];
    bool isCodeBlock = false;
    StringBuffer codeBuffer = StringBuffer();

    void flushCodeBlock() {
      if (codeBuffer.isNotEmpty) {
        widgets.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              codeBuffer.toString(),
              textDirection: TextDirection.ltr,
              style: AppStyle.styleRegular14(context).copyWith(
                fontFamily: 'monospace',
                color: Colors.blueGrey.shade800,
              ),
            ),
          ),
        );
        codeBuffer.clear();
      }
    }

    for (var line in lines) {
      if (line.trim().startsWith('```')) {
        if (isCodeBlock) {
          flushCodeBlock();
        }
        isCodeBlock = !isCodeBlock;
      } else if (isCodeBlock) {
        codeBuffer.writeln(line);
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              line.trim(),
              style: AppStyle.styleRegular14(context),
              textAlign: TextAlign.right,
            ),
          ),
        );
      }
    }

    flushCodeBlock();
    return widgets;
  }
}
