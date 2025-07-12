import 'package:flutter/material.dart';

import '../../../../core/constants/color_app.dart';
import '../../../../core/utils/app_style.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String selected;
  final Function(String) onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onTap(label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppStyle.styleRegular12(
                  context,
                ).copyWith(color: isSelected ? Colors.white : Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
