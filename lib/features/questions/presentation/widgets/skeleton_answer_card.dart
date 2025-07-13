import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonAnswerCard extends StatelessWidget {
  const SkeletonAnswerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
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
            // عنوان "إجابة رقم ..."
            Container(height: 20, width: 100, color: Colors.white),
            const SizedBox(height: 12),
            // نص الإجابة placeholder (عدة أسطر)
            Column(
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
