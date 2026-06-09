import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class BudgetSelector extends StatelessWidget {
  final double selectedBudget;
  final ValueChanged<double> onChanged;

  BudgetSelector({
    super.key,
    required this.selectedBudget,
    required this.onChanged,
  });

  final _budgets = [20000.0, 35000.0, 50000.0, 80000.0, 100000.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _budgets.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final budget = _budgets[index];
              final isSelected = budget == selectedBudget;
              final label = budget >= 100000
                  ? '₱100K+'
                  : '₱${NumberFormat('#,###').format(budget)}';
              return GestureDetector(
                onTap: () => onChanged(budget),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.cyanDim : AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.cyan : AppColors.textHint,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? AppColors.cyan
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
