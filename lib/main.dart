import 'package:flutter/material.dart';

import 'core/constants/color_app.dart' show AppColors;
import 'core/utils/app_style.dart';
import 'features/questions/presentation/views/questions_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stack Overflow',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          titleTextStyle: AppStyle.styleSemiBold20(context),
        ),
      ),
      home: const QuestionsPage(),
    );
  }
}