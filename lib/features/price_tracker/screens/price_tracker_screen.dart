import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/price_tracker_bloc.dart';
import '../bloc/price_tracker_event.dart';
import '../bloc/price_tracker_state.dart';
import '../widgets/component_price_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PriceTrackerScreen extends StatefulWidget {
  final ValueNotifier<int>? tabNotifier;
  final int tabIndex;

  const PriceTrackerScreen({super.key, this.tabNotifier, this.tabIndex = 1});

  @override
  State<PriceTrackerScreen> createState() => _PriceTrackerScreenState();
}

class _PriceTrackerScreenState extends State<PriceTrackerScreen> {
  String _selectedFilter = 'all';

  final _filters = ['all', 'sale', 'hike', 'saved'];

  @override
  void initState() {
    super.initState();
    context.read<PriceTrackerBloc>().add(const LoadComponents());
    widget.tabNotifier?.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.tabNotifier?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (widget.tabNotifier?.value == widget.tabIndex) {
      Future.microtask(() {
        if (mounted) {
          context.read<PriceTrackerBloc>().add(LoadComponents(filter: _selectedFilter));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Price Tracker',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = f == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        f == 'all'
                            ? 'All'
                            : f == 'sale'
                                ? 'On Sale'
                                : f == 'hike'
                                    ? 'Price Hike'
                                    : 'Saved',
                        style: AppTextStyles.bodySmall,
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedFilter = f);
                        context
                            .read<PriceTrackerBloc>()
                            .add(LoadComponents(filter: f));
                      },
                      selectedColor: AppColors.cyanDim,
                      checkmarkColor: AppColors.cyan,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.cyan
                            : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.cyan : AppColors.textHint,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PriceTrackerBloc>()
                    .add(RefreshComponents());
              },
              child: BlocBuilder<PriceTrackerBloc, PriceTrackerState>(
                builder: (context, state) {
                  if (state is PriceTrackerLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cyan,
                      ),
                    );
                  }
                  if (state is PriceTrackerError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.hikeOrange),
                      ),
                    );
                  }
                  if (state is PriceTrackerLoaded) {
                    if (state.components.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 48, color: AppColors.textHint),
                            const SizedBox(height: 12),
                            Text(
                              'No components found',
                              style: AppTextStyles.bodyLarge
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: state.components.length,
                      itemBuilder: (context, index) {
                        final component = state.components[index];
                        return ComponentPriceCard(
                          component: component,
                          isWatched: state.watchlistIds
                              .contains(component['id']),
                          onToggleWatchlist: () {
                            context.read<PriceTrackerBloc>().add(
                                  ToggleWatchlist(
                                    component['id'] as String,
                                    component,
                                  ),
                                );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
