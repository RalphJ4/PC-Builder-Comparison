import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../build_advisor/screens/build_advisor_screen.dart';
import '../../price_tracker/screens/price_tracker_screen.dart';
import '../../alerts/screens/alerts_screen.dart';
import '../../saved_builds/screens/saved_builds_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _tabNotifier = ValueNotifier<int>(0);

  late final _screens = [
    const BuildAdvisorScreen(),
    PriceTrackerScreen(tabNotifier: _tabNotifier, tabIndex: 1),
    AlertsScreen(tabNotifier: _tabNotifier, tabIndex: 2),
    SavedBuildsScreen(tabNotifier: _tabNotifier, tabIndex: 3),
  ];

  @override
  void dispose() {
    _tabNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.textHint.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() {
            _selectedIndex = i;
            _tabNotifier.value = i;
          }),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.cyan,
          unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.build_circle_outlined),
              activeIcon: Icon(Icons.build_circle),
              label: 'Build',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              activeIcon: Icon(Icons.trending_up),
              label: 'Prices',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
          ],
        ),
      ),
    );
  }
}
