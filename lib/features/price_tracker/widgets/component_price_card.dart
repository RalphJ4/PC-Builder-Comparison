import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/pc_component.dart';
import '../../../core/models/price_snapshot.dart';
import '../../build_advisor/widgets/build_result_card.dart';

class ComponentPriceCard extends StatelessWidget {
  final Map<String, dynamic> component;
  final bool isWatched;
  final VoidCallback onToggleWatchlist;

  const ComponentPriceCard({
    super.key,
    required this.component,
    required this.isWatched,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat('#,###');
    final name = component['name'] as String? ?? 'Unknown';
    final category = component['category'] as String? ?? '';
    final statusStr = component['status'] as String? ?? 'normal';
    final status = PriceStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => PriceStatus.normal,
    );
    final prices = component['prices'] as Map<String, dynamic>? ?? {};
    final snapshot = PriceSnapshot.fromJson(prices);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cyanDim,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.cyan),
                      ),
                    ),
                  const SizedBox(width: 8),
                  buildStatusBadge(status),
                ],
              ),
              IconButton(
                onPressed: onToggleWatchlist,
                icon: Icon(
                  isWatched ? Icons.bookmark : Icons.bookmark_border,
                  color: isWatched ? AppColors.cyan : AppColors.textHint,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (snapshot.shopee != null)
            _buildStorePriceRow(
              'Shopee',
              snapshot.shopee!,
              AppColors.shopeeRed,
              snapshot.bestPrice,
              format,
            ),
          if (snapshot.lazada != null)
            _buildStorePriceRow(
              'Lazada',
              snapshot.lazada!,
              AppColors.lazadaBlue,
              snapshot.bestPrice,
              format,
            ),
          if (snapshot.manila != null)
            _buildStorePriceRow(
              snapshot.manilaStoreName.isNotEmpty
                  ? snapshot.manilaStoreName
                  : 'Manila Store',
              snapshot.manila!,
              AppColors.manilaStore,
              snapshot.bestPrice,
              format,
            ),
          if (snapshot.bestPrice > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.saleBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Best price on ${snapshot.bestStore}',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.saleGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStorePriceRow(
    String store,
    double price,
    Color dotColor,
    double bestPrice,
    NumberFormat format,
  ) {
    final isBest = price == bestPrice;
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
