import 'package:flutter/material.dart';

import '../../../../core/utils/app_style.dart';
import 'filter_button.dart';

class SearchAndFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const SearchAndFilterBar({
    super.key,
    required this.controller,
    required this.selectedFilter,
    required this.onFilterChanged, required void Function() onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'ابحث في الأسئلة....',

              hintStyle: AppStyle.styleRegular14(
                context,
              ).copyWith(color: Colors.grey),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterButton(
                  label: 'الأحدث',
                  icon: Icons.access_time,
                  selected: selectedFilter,
                  onTap: onFilterChanged,
                ),
                FilterButton(
                  label: 'الأكثر تصويتاً',
                  icon: Icons.thumb_up,
                  selected: selectedFilter,
                  onTap: onFilterChanged,
                ),
                FilterButton(
                  label: 'الأكثر إجابة',
                  icon: Icons.comment,
                  selected: selectedFilter,
                  onTap: onFilterChanged,
                ),
                FilterButton(
                  label: 'الأكثر مشاهدة',
                  icon: Icons.remove_red_eye,
                  selected: selectedFilter,
                  onTap: onFilterChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
