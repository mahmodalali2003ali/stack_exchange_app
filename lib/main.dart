import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/color_app.dart' ;
import 'core/utils/app_style.dart';
import 'core/utils/service_locator.dart';
import 'features/questions/presentation/manager/question/question_cubit.dart';
import 'features/questions/presentation/views/questions_page.dart';
import 'my_observer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
  
  await init();
  runApp(MyApp());
  Bloc.observer = MyObserver();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QuestionCubit>()..fetchQuestions(isRefresh: true)),
],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stack Overflow',

        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },

        theme: ThemeData(
          fontFamily: 'Tajawal',
          primaryColor: AppColors.primaryColor,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            titleTextStyle: AppStyle.styleSemiBold20(context),
            centerTitle: true,
            elevation: 1,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),

        home: const QuestionsPage(),
      ),
    );
  }
}
