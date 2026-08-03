import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/page_transitions.dart';
import '../auth/welcome_screen.dart';
import '../map/kerala_map_screen.dart';
import '../profile/profile_screen.dart';
import 'districts_screen.dart';
import 'weather_dashboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // Session was invalidated while the app was open (token expired,
        // forced logout after a rejected 401, etc.) - tear down every page
        // inside the shell and send the user back to Welcome immediately.
        // No screen inside HomeShell is reachable once this fires.
        if (auth.status == AuthStatus.unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              fadeScaleRoute(const WelcomeScreen()),
              (route) => false,
            );
          });
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final isPresident = auth.currentUser?.isPresident ?? false;

        final pages = [
          const WeatherDashboardScreen(),
          const DistrictsScreen(),
          const KeralaMapScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          // IndexedStack keeps every tab's state alive (scroll position, loaded
          // data) and switches between them with zero rebuild cost - the
          // fastest possible tab switch, so it's kept as-is on purpose.
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            selectedItemColor: isPresident ? AppColors.presidentGold : AppColors.primary,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.cloud_outlined),
                activeIcon: const Icon(Icons.cloud_rounded),
                label: isPresident ? 'Command Center' : 'Weather',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map_rounded),
                label: 'Districts',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.public_outlined),
                activeIcon: Icon(Icons.public_rounded),
                label: 'Map',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
