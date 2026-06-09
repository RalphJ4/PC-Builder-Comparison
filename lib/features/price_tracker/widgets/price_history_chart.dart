import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/price_snapshot.dart';

class PriceHistoryChart extends StatelessWidget {
  final List<PriceSnapshot> snapshots;

  const PriceHistoryChart({super.key, required this.snapshots});

  @override
  Widget build(BuildContext context) {
    if (snapshots.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = List<PriceSnapshot>.from(snapshots)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final shopeeSpots = <FlSpot>[];
    final lazadaSpots = <FlSpot>[];
    final manilaSpots = <FlSpot>[];

    for (var i = 0; i < sorted.length; i++) {
      final s = sorted[i];
      if (s.shopee != null) shopeeSpots.add(FlSpot(i.toDouble(), s.shopee!));
      if (s.lazada != null) lazadaSpots.add(FlSpot(i.toDouble(), s.lazada!));
      if (s.manila != null) manilaSpots.add(FlSpot(i.toDouble(), s.manila!));
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.textHint.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            if (shopeeSpots.length > 1)
              LineChartBarData(
                spots: shopeeSpots,
                color: AppColors.shopeeRed,
                barWidth: 2,
                dotData: FlDotData(show: false),
                isCurved: true,
              ),
            if (lazadaSpots.length > 1)
              LineChartBarData(
                spots: lazadaSpots,
                color: AppColors.lazadaBlue,
                barWidth: 2,
                dotData: FlDotData(show: false),
                isCurved: true,
              ),
            if (manilaSpots.length > 1)
              LineChartBarData(
                spots: manilaSpots,
                color: AppColors.manilaStore,
                barWidth: 2,
                dotData: FlDotData(show: false),
                isCurved: true,
              ),
          ],
        ),
      ),
    );
  }
}
