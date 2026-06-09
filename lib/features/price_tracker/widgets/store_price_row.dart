import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class StorePriceRow extends StatelessWidget {
  final String store;
  final double price;
  final Color dotColor;
  final bool isBest;

  const StorePriceRow({
    super.key,
    required this.store,
    required this.price,
    required this.dotColor,
    this.isBest = false,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                store,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          Text(
            '₱${format.format(price)}',
            style: AppTextStyles.price.copyWith(
              color: isBest ? AppColors.saleGreen : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
