import 'package:flutter/material.dart';

import '../../../../core/utils/app_style.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Center(child: Text('Questions', style: AppStyle.styleSemiBold24(context))),
      ),
    );
  }
}
