import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/constants/app_colors.dart';
import 'core/services/ai_service.dart';
import 'core/services/price_service.dart';
import 'core/services/notification_service.dart';
import 'features/build_advisor/bloc/build_advisor_bloc.dart';
import 'features/build_advisor/screens/build_advisor_screen.dart';
import 'features/price_tracker/bloc/price_tracker_bloc.dart';
import 'features/price_tracker/screens/price_tracker_screen.dart';
import 'features/alerts/screens/alerts_screen.dart';
import 'features/saved_builds/screens/saved_builds_screen.dart';
import 'features/home/screens/home_screen.dart';

final _priceService = PriceService();
final _notificationService = NotificationService();

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/build', builder: (_, _) => const BuildAdvisorScreen()),
    GoRoute(path: '/prices', builder: (_, _) => const PriceTrackerScreen()),
    GoRoute(path: '/alerts', builder: (_, _) => const AlertsScreen()),
    GoRoute(path: '/saved', builder: (_, _) => const SavedBuildsScreen()),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  await _notificationService.initialize();

  runApp(const PcBuildFinderApp());
}

class PcBuildFinderApp extends StatelessWidget {
  const PcBuildFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();
    final displayTextTheme = GoogleFonts.spaceGroteskTextTheme();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BuildAdvisorBloc(AiService()),
        ),
        BlocProvider(
          create: (_) => PriceTrackerBloc(_priceService),
        ),
      ],
      child: MaterialApp.router(
        title: 'PC Build Finder PH',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.cyan,
            secondary: AppColors.cyan,
            surface: AppColors.surface,
          ),
          textTheme: textTheme.copyWith(
            displayLarge: displayTextTheme.displayLarge,
            displayMedium: displayTextTheme.displayMedium,
            bodyLarge: textTheme.bodyLarge,
            bodySmall: textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
