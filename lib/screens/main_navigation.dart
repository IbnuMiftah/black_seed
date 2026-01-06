import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    HomeScreen(
      onTabChange: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    const ChatScreen(),
    const LibraryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      body: Stack(
        children: [
          // Main Content
          _screens[_currentIndex],
          
          // Floating Navigation Bar
          Positioned(
            left: 40,
            right: 40,
            bottom: 30,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E2432).withAlpha(230),
                          const Color(0xFF1A1D29).withAlpha(230),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: const Color(0xFF00CBA9).withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            index: 0,
                          ),
                          _buildNavItem(
                            icon: Icons.chat_bubble_rounded,
                            label: 'Chats',
                            index: 1,
                          ),
                          _buildNavItem(
                            icon: Icons.library_books_rounded,
                            label: 'Library',
                            index: 2,
                          ),
                          _buildNavItem(
                            icon: Icons.settings_rounded,
                            label: 'Settings',
                            index: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;
    final Color activeColor = const Color(0xFF00CBA9);
    final Color inactiveColor = Colors.white.withAlpha(128);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
