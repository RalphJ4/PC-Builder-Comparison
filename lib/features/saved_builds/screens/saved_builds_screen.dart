import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/pc_build.dart';
import '../widgets/saved_build_tile.dart';

class SavedBuildsScreen extends StatefulWidget {
  final ValueNotifier<int>? tabNotifier;
  final int tabIndex;

  const SavedBuildsScreen({super.key, this.tabNotifier, this.tabIndex = 3});

  @override
  State<SavedBuildsScreen> createState() => _SavedBuildsScreenState();
}

class _SavedBuildsScreenState extends State<SavedBuildsScreen> {
  List<PcBuild> _builds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBuilds();
    widget.tabNotifier?.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.tabNotifier?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (widget.tabNotifier?.value == widget.tabIndex) {
      Future.microtask(_loadBuilds);
    }
  }

  Future<void> _loadBuilds() async {
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final buildsJson = prefs.getStringList('saved_builds') ?? [];
      _builds = buildsJson
          .map((e) => PcBuild.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _deleteBuildPersisted(int deletedIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final buildsJson = prefs.getStringList('saved_builds') ?? [];
    buildsJson.removeAt(deletedIndex);
    await prefs.setStringList('saved_builds', buildsJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Saved Builds',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.cyan),
            )
          : _builds.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open,
                          size: 48, color: AppColors.textHint),
                      const SizedBox(height: 12),
                      Text(
                        'No saved builds yet',
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Generate a build and save it here',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBuilds,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _builds.length,
                    itemBuilder: (context, index) {
                      final build = _builds[index];
                      return Dismissible(
                        key: Key(build.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.hikeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete,
                              color: AppColors.hikeOrange),
                        ),
                        onDismissed: (_) {
                          _builds.removeAt(index);
                          _deleteBuildPersisted(index);
                        },
                        child: SavedBuildTile(
                          build: build,
                          onTap: () => _showBuildDetails(build),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showBuildDetails(PcBuild build) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final format = NumberFormat('#,###');
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textHint,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    build.summary,
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Components',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: build.components.map((c) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cyanDim,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              c.category,
                              style: AppTextStyles.label
                                  .copyWith(color: AppColors.cyan),
                            ),
                          ),
                          title: Text(
                            c.name,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textPrimary),
                          ),
                          subtitle: Text(
                            '₱${format.format(c.prices.bestPrice)}',
                            style: AppTextStyles.price
                                .copyWith(color: AppColors.saleGreen),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(color: AppColors.textHint),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.displayMedium
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      Text(
                        '₱${format.format(build.totalMin)} - ₱${format.format(build.totalMax)}',
                        style: AppTextStyles.price
                            .copyWith(color: AppColors.cyan),
                      ),
                    ],
                  ),
                  if (build.estimatedSavings > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Estimated savings: ₱${format.format(build.estimatedSavings)}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.saleGreen),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
