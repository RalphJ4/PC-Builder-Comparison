import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/build_advisor_bloc.dart';
import '../bloc/build_advisor_event.dart';
import '../bloc/build_advisor_state.dart';
import '../widgets/budget_selector.dart';
import '../widgets/use_case_chips.dart';
import '../widgets/build_result_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class BuildAdvisorScreen extends StatefulWidget {
  const BuildAdvisorScreen({super.key});

  @override
  State<BuildAdvisorScreen> createState() => _BuildAdvisorScreenState();
}

class _BuildAdvisorScreenState extends State<BuildAdvisorScreen> {
  double _selectedBudget = 50000;
  String _selectedUseCase = 'Gaming';
  final List<String> _selectedPriorities = [];
  String _selectedPeripherals = 'PC only';
  String _selectedStores = 'All sources';
  final Set<String> _savedIds = {};

  final _useCases = [
    'Gaming',
    'Content Creation',
    'Office/Study',
    'Programming',
    'Streaming',
  ];

  final _priorities = [
    'High FPS',
    'Future-proof',
    'Silent/cool',
    'Compact',
    'Best value',
  ];

  final _peripheralOptions = ['PC only', 'Full setup', 'Monitor only'];
  final _storeOptions = ['All sources', 'Manila stores', 'Online only'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'PC Build Finder PH',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            _buildPulseDot(),
          ],
        ),
      ),
      body: BlocConsumer<BuildAdvisorBloc, BuildAdvisorState>(
        listener: (_, _) {},
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetSelector(
                  selectedBudget: _selectedBudget,
                  onChanged: (v) => setState(() => _selectedBudget = v),
                ),
                const SizedBox(height: 20),
                UseCaseChips(
                  useCases: _useCases,
                  selected: _selectedUseCase,
                  onChanged: (v) => setState(() => _selectedUseCase = v),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Priorities'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _priorities.map((p) {
                    final selected = _selectedPriorities.contains(p);
                    return FilterChip(
                      label: Text(p, style: AppTextStyles.bodySmall),
                      selected: selected,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedPriorities.add(p);
                          } else {
                            _selectedPriorities.remove(p);
                          }
                        });
                      },
                      selectedColor: AppColors.cyanDim,
                      checkmarkColor: AppColors.cyan,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: selected
                            ? AppColors.cyan
                            : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: selected ? AppColors.cyan : AppColors.textHint,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Peripherals'),
                const SizedBox(height: 8),
                _buildSegmentedControl(_peripheralOptions, _selectedPeripherals,
                    (v) => setState(() => _selectedPeripherals = v)),
                const SizedBox(height: 20),
                _buildSectionTitle('Store Preference'),
                const SizedBox(height: 8),
                _buildSegmentedControl(_storeOptions, _selectedStores,
                    (v) => setState(() => _selectedStores = v)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state is BuildAdvisorLoading
                        ? null
                        : () {
                            context.read<BuildAdvisorBloc>().add(
                                  GenerateBuildEvent(
                                    budget: _selectedBudget,
                                    useCase: _selectedUseCase,
                                    priorities: _selectedPriorities,
                                    peripherals: _selectedPeripherals,
                                    stores: _selectedStores,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state is BuildAdvisorLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Generate Build + Compare Prices',
                            style: AppTextStyles.bodyLarge
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                if (state is BuildAdvisorLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is BuildAdvisorSuccess)
                  Column(
                    children: [
                      BuildResultCard(build: state.build),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<BuildAdvisorBloc>().add(
                                  SaveBuildEvent(state.build),
                                );
                            _savedIds.add(state.build.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Build saved!'),
                                backgroundColor: AppColors.saleGreen,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            _savedIds.contains(state.build.id)
                                ? Icons.check_circle
                                : Icons.bookmark_add,
                            size: 18,
                          ),
                          label: Text(
                            _savedIds.contains(state.build.id)
                                ? 'Saved'
                                : 'Save Build',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _savedIds.contains(state.build.id)
                                ? AppColors.saleGreen
                                : AppColors.cyan,
                            foregroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (state is BuildAdvisorError)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.hikeBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.hikeOrange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.hikeOrange),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPulseDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.cyan.withValues(alpha: 0.3 + 0.7 * value),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () => setState(() {}),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
    );
  }

  Widget _buildSegmentedControl(
    List<String> options,
    String selected,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyanDim : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  option,
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
        }).toList(),
      ),
    );
  }
}
