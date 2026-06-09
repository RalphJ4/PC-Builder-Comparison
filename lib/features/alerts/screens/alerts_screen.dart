import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/price_service.dart';
import '../widgets/alert_notification_card.dart';

class AlertsScreen extends StatefulWidget {
  final ValueNotifier<int>? tabNotifier;
  final int tabIndex;

  const AlertsScreen({super.key, this.tabNotifier, this.tabIndex = 2});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _priceService = PriceService();
  List<Map<String, dynamic>> _alerts = [];
  bool _loading = true;
  String _selectedSegment = 'all';

  @override
  void initState() {
    super.initState();
    _loadAlerts();
    widget.tabNotifier?.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.tabNotifier?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (widget.tabNotifier?.value == widget.tabIndex) {
      Future.microtask(_loadAlerts);
    }
  }

  Future<void> _loadAlerts() async {
    setState(() => _loading = true);
    try {
      final alerts = await _priceService.getAlerts(
        type: _selectedSegment == 'all' ? null : _selectedSegment,
      );
      setState(() {
        _alerts = alerts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final segments = ['All', 'Sales', 'Hikes'];
    final segmentValues = ['all', 'sale', 'hike'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Alerts',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(segments.length, (i) {
                final isSelected = segmentValues[i] == _selectedSegment;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedSegment = segmentValues[i]);
                      _loadAlerts();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.cyanDim : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        segments[i],
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? AppColors.cyan
                              : AppColors.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.cyan),
                  )
                : _alerts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none,
                                size: 48, color: AppColors.textHint),
                            const SizedBox(height: 12),
                            Text(
                              'No alerts yet',
                              style: AppTextStyles.bodyLarge
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Price changes will appear here',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAlerts,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: _alerts.length,
                          itemBuilder: (context, index) {
                            return AlertNotificationCard(
                              alert: _alerts[index],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
