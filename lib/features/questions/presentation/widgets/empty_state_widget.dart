import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_style.dart';
import '../manager/question/question_cubit.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const EmptyStateWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات متاحة',
            style: AppStyle.styleSemiBold16(context),
          ),
          const SizedBox(height: 8),
          Text(
            'تحقق من الاتصال بالإنترنت أو حاول تحميل البيانات المحلية',
            style: AppStyle.styleRegular14(context).copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('إعادة المحاولة'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<QuestionCubit>().fetchQuestions(
                        fromLocal: true,
                        isRefresh: true,
                      );
                },
                child: const Text('تحميل البيانات المحلية'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}