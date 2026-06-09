import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/pc_build.dart';
import '../../../core/models/pc_component.dart';


class BuildResultCard extends StatelessWidget {
  final PcBuild pcBuild;

  const BuildResultCard({super.key, required PcBuild build}) : pcBuild = build;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Build Overview',
                style: AppTextStyles.displayMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                pcBuild.summary,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...pcBuild.components.map((component) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ComponentCard(component: component),
            )),
        const SizedBox(height: 16),
        _buildTotalBar(currencyFormat),
      ],
    );
  }

  Widget _buildTotalBar(NumberFormat format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated Total',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '₱${format.format(pcBuild.totalMin)} - ₱${format.format(pcBuild.totalMax)}',
                style: AppTextStyles.displayMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          if (pcBuild.estimatedSavings > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.saleBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.savings,
                      size: 14, color: AppColors.saleGreen),
                  const SizedBox(width: 4),
                  Text(
                    'Save ₱${format.format(pcBuild.estimatedSavings)}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.saleGreen),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final PcComponent component;

  const _ComponentCard({required this.component});

  @override
  Widget build(BuildContext context) {

    return Container(
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyanDim,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  component.category,
                  style: AppTextStyles.label.copyWith(color: AppColors.cyan),
                ),
              ),
              buildStatusBadge(component.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            component.name,
            style: AppTextStyles.bodyLarge
                .copyWith(color: AppColors.textPrimary),
          ),
          if (component.why.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              component.why,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 12),
          if (component.prices.shopee != null)
            _buildPriceRow('Shopee', component.prices.shopee!,
                AppColors.shopeeRed, component.prices.bestPrice),
          if (component.prices.lazada != null)
            _buildPriceRow('Lazada', component.prices.lazada!,
                AppColors.lazadaBlue, component.prices.bestPrice),
          if (component.prices.manila != null)
            _buildPriceRow(
              component.prices.manilaStoreName.isNotEmpty
                  ? component.prices.manilaStoreName
                  : 'Manila Store',
              component.prices.manila!,
              AppColors.manilaStore,
              component.prices.bestPrice,
            ),
          if (component.statusNote.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: component.status == PriceStatus.sale
                    ? AppColors.saleBg
                    : component.status == PriceStatus.hike
                        ? AppColors.hikeBg
                        : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    component.status == PriceStatus.sale
                        ? Icons.arrow_downward
                        : component.status == PriceStatus.hike
                            ? Icons.arrow_upward
                            : Icons.info_outline,
                    size: 14,
                    color: component.status == PriceStatus.sale
                        ? AppColors.saleGreen
                        : component.status == PriceStatus.hike
                            ? AppColors.hikeOrange
                            : AppColors.textHint,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      component.statusNote,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String store, double price, Color dotColor, double bestPrice) {
    final isBest = price == bestPrice;
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

Widget buildStatusBadge(PriceStatus status) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: status == PriceStatus.sale
          ? AppColors.saleBg
          : status == PriceStatus.hike
              ? AppColors.hikeBg
              : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: status == PriceStatus.sale
            ? AppColors.saleGreen
            : status == PriceStatus.hike
                ? AppColors.hikeOrange
                : AppColors.textHint,
        width: 0.5,
      ),
    ),
    child: Text(
      status == PriceStatus.sale
          ? 'Sale'
          : status == PriceStatus.hike
              ? 'Hike'
              : 'Normal',
      style: AppTextStyles.label.copyWith(
        color: status == PriceStatus.sale
            ? AppColors.saleGreen
            : status == PriceStatus.hike
                ? AppColors.hikeOrange
                : AppColors.textHint,
      ),
    ),
  );
}
