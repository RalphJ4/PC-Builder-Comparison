import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/pc_build.dart';

class SavedBuildTile extends StatelessWidget {
  final PcBuild pcBuild;
  final VoidCallback onTap;

  const SavedBuildTile({
    super.key,
    required PcBuild build,
    required this.onTap,
  }) : pcBuild = build;

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
    final dateFormat = DateFormat('MMM d, yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.cyanDim,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.computer,
                color: AppColors.cyan,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pcBuild.config.useCase.isNotEmpty
                        ? '${pcBuild.config.useCase} Build'
                        : 'PC Build',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        dateFormat.format(pcBuild.createdAt),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${pcBuild.components.length} parts',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₱${format.format(pcBuild.totalMin)}',
                  style: AppTextStyles.price.copyWith(
                    color: AppColors.cyan,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '₱${format.format(pcBuild.config.budget)} budget',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
