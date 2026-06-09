import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class UseCaseChips extends StatelessWidget {
  final List<String> useCases;
  final String selected;
  final ValueChanged<String> onChanged;

  const UseCaseChips({
    super.key,
    required this.useCases,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Use Case',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: useCases.map((uc) {
            final isSelected = uc == selected;
            return FilterChip(
              label: Text(uc, style: AppTextStyles.bodySmall),
              selected: isSelected,
              onSelected: (_) => onChanged(uc),
              selectedColor: AppColors.cyanDim,
              checkmarkColor: AppColors.cyan,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.cyan : AppColors.textSecondary,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.cyan : AppColors.textHint,
                width: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
