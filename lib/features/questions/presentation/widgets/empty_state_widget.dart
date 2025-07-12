import 'package:flutter/material.dart';

import '../../../../core/utils/app_style.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('لا توجد نتائج للبحث', style: AppStyle.styleMedium20(context)),
          const SizedBox(height: 8),
          Text(
            'حاول استخدام كلمات بحث مختلفة',
            style: AppStyle.styleRegular14(
              context,
            ).copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
