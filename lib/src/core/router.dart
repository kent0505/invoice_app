import 'package:go_router/go_router.dart';

import '../features/business/models/business.dart';
import '../features/business/screens/business_screen.dart';
import '../features/business/screens/create_business_screen.dart';
import '../features/business/screens/edit_business_screen.dart';
import '../features/business/screens/signature_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/onboard/screens/onboard_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/splash/screens/splash_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => const HomeScreen(),
    ),

    // settings
    GoRoute(
      path: SettingsScreen.routePath,
      builder: (context, state) => const SettingsScreen(),
    ),

    // business
    GoRoute(
      path: BusinessScreen.routePath,
      builder: (context, state) => const BusinessScreen(),
    ),
    GoRoute(
      path: CreateBusinessScreen.routePath,
      builder: (context, state) => const CreateBusinessScreen(),
    ),
    GoRoute(
      path: EditBusinessScreen.routePath,
      builder: (context, state) => EditBusinessScreen(
        business: state.extra as Business,
      ),
    ),
    GoRoute(
      path: SignatureScreen.routePath,
      builder: (context, state) => const SignatureScreen(),
    ),
  ],
);
