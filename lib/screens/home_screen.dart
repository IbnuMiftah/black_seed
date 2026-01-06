import 'package:flutter/material.dart';
import 'dart:ui';
import 'library_screen.dart';
import 'emergency_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;

  const HomeScreen({
    super.key,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29), // Deep Charcoal
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1D29), // Deep Charcoal
              const Color(0xFF0F1419), // Darker shade
              const Color(0xFF1E2432), // Deep Midnight Navy
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // App Logo
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF00CBA9).withAlpha(230),
                            const Color(0xFF5FFFD7).withAlpha(230),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00CBA9).withAlpha(60), // Reduced from 102
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'BlackSeed',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Greeting
                      Text(
                        'Good Evening',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withAlpha(179),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Main Heading
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: 'Hello, how are you\n'),
                            TextSpan(
                              text: 'feeling?',
                              style: TextStyle(
                                color: Color(0xFF00CBA9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Medical Disclaimer - Tone down glow
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withAlpha(20), // More subtle glass
                              Colors.white.withAlpha(10),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withAlpha(26),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00CBA9).withAlpha(26), // Subtle Teal
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFF00CBA9),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'This app does not provide medical advice. Always consult a healthcare professional for serious symptoms.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withAlpha(204), // Clean white text
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),



                      const SizedBox(height: 40),

                      // Quick Actions Header
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Actions Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          _buildQuickActionCard(
                            icon: Icons.medical_services_outlined,
                            title: 'Symptom\nChecker',
                            subtitle: 'Analyze signs',
                            gradientColors: [
                              const Color(0xFFFF6B6B).withAlpha(77),
                              const Color(0xFFFF8E8E).withAlpha(51),
                            ],
                            iconColor: const Color(0xFFFF6B6B),
                            decorationColor: const Color(0xFFFF6B6B).withAlpha(26),
                            onTap: () {
                              onTabChange(1); // Navigate to Chat (Index 1)
                            },
                          ),
                          _buildQuickActionCard(
                            icon: Icons.library_books_outlined,
                            title: 'Library',
                            subtitle: 'Read articles',
                            gradientColors: [
                              const Color(0xFF4E9FFF).withAlpha(77),
                              const Color(0xFF6BB1FF).withAlpha(51),
                            ],
                            iconColor: const Color(0xFF4E9FFF),
                            decorationColor: const Color(0xFF4E9FFF).withAlpha(26),
                            onTap: () {
                              onTabChange(2); // Navigate to Library (Index 2)
                            },
                          ),
                          _buildQuickActionCard(
                            icon: Icons.bookmark_outline,
                            title: 'Saved\nSessions',
                            subtitle: 'Your history',
                            gradientColors: [
                              const Color(0xFFB084FF).withAlpha(77),
                              const Color(0xFFC29FFF).withAlpha(51),
                            ],
                            iconColor: const Color(0xFFB084FF),
                            decorationColor: const Color(0xFFB084FF).withAlpha(26),
                            onTap: () {
                              onTabChange(2); // Navigate to Library (Index 2)
                            },
                          ),
                          _buildQuickActionCard(
                            icon: Icons.emergency,
                            title: 'Emergency',
                            subtitle: 'Get help now',
                            gradientColors: [
                              const Color(0xFFFFAB40).withAlpha(77),
                              const Color(0xFFFFBD5B).withAlpha(51),
                            ],
                            iconColor: const Color(0xFFFFAB40),
                            decorationColor: const Color(0xFFFFAB40).withAlpha(26),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const EmergencyScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      
                      // Spacing for Bottom Navigation Bar
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required Color iconColor,
    required Color decorationColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: Border.all(
          color: iconColor.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60), // Changed from colored glow to subtle black shadow
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: decorationColor,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: iconColor.withAlpha(51),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            icon,
                            color: iconColor,
                            size: 28,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
