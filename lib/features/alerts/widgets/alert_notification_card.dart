import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class AlertNotificationCard extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertNotificationCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final isSale = alert['type'] == 'sale';
    final format = NumberFormat('#,###');
    final oldPrice = (alert['oldPrice'] as num).toDouble();
    final newPrice = (alert['newPrice'] as num).toDouble();
    final changePct = (alert['changePercent'] as num).toDouble();
    final createdAt = alert['createdAt'] != null
        ? (alert['createdAt'] as dynamic).toDate() as DateTime
        : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isSale ? AppColors.saleGreen : AppColors.hikeOrange,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSale ? AppColors.saleBg : AppColors.hikeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSale
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 12,
                        color:
                            isSale ? AppColors.saleGreen : AppColors.hikeOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isSale ? 'Sale' : 'Hike',
                        style: AppTextStyles.label.copyWith(
                          color: isSale
                              ? AppColors.saleGreen
                              : AppColors.hikeOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTimeAgo(createdAt),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textHint),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              alert['componentName'] as String? ?? 'Unknown',
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              alert['store'] as String? ?? '',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '₱${format.format(oldPrice)}',
                  style: AppTextStyles.price.copyWith(
                    color: AppColors.textHint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isSale ? Icons.arrow_forward : Icons.arrow_forward,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '₱${format.format(newPrice)}',
                  style: AppTextStyles.price.copyWith(
                    color: isSale ? AppColors.saleGreen : AppColors.hikeOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSale ? AppColors.saleBg : AppColors.hikeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${isSale ? '-' : '+'}${changePct.toStringAsFixed(1)}%',
                    style: AppTextStyles.label.copyWith(
                      color:
                          isSale ? AppColors.saleGreen : AppColors.hikeOrange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }
}
