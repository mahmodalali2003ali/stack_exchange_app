import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';
import '../../domain/entities/question.dart';
import '../manager/QuestionDetails/question_details_cubit.dart';
import '../manager/QuestionDetails/question_details_state.dart';
import '../widgets/answer_card.dart';
import '../widgets/question_header.dart';
import '../widgets/question_body.dart';
import '../../data/datasources/remote/questions_api_service.dart';
import '../../../../core/services/dio_client.dart';


class QuestionDetailsPage extends StatelessWidget {
  final Question question;
  const QuestionDetailsPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final apiService = QuestionsApiService(DioClient());

    return BlocProvider(
      create: (_) {
        final cubit = QuestionDetailsCubit(apiService);
        cubit.fetchQuestionDetails(question.id);
        return cubit;
      },
      child: Scaffold(
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
        body: BlocBuilder<QuestionDetailsCubit, QuestionDetailsState>(
          builder: (context, state) {
            if (state is QuestionDetailsLoading) {
              return _buildLoadingSkeleton(context);
            } else if (state is QuestionDetailsLoaded) {
              return _buildContent(context, state.question, state.answers);
            } else if (state is QuestionDetailsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Question question, List<String> answers) {
    return SingleChildScrollView(
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
          _buildAnswersSection(context, answers),
        ],
      ),
    );
  }

  Widget _buildAnswersSection(BuildContext context, List<String> answers) {
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

  Widget _buildLoadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            height: 180,
            margin: const EdgeInsets.only(bottom: 24),
          ),
          Container(
            height: 30,
            width: 120,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.only(bottom: 12),
          ),
          ...List.generate(3, (_) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              height: 120,
            );
          }),
        ],
      ),
    );
  }
}
