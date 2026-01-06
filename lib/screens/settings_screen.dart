import 'package:flutter/material.dart';
import 'dart:ui';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'EN';
  String _selectedTextSize = 'Medium';
  final List<String> _textSizes = ['Small', 'Medium', 'Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
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
                            color: const Color(0xFF00CBA9).withAlpha(102),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'BlackSeed AI',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF00CBA9).withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Extra bottom padding for nav bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('ACCOUNT'),
                      const SizedBox(height: 16),
                      
                      // Profile Card
                      _buildGlassCard(
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(26),
                                border: Border.all(
                                  color: const Color(0xFF00CBA9),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white.withAlpha(204),
                                ),
                                // In a real app, use Image.asset or network image here
                                // child: Image.asset('assets/images/user.png', fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Dr. Almaz Bekele',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF00CBA9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pro Member',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withAlpha(153),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(13),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.white.withAlpha(179),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Stats Row (Only Checkups as requested)
                      Row(
                        children: [
                          Expanded(
                            child: _buildGlassCard(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Column(
                                children: [
                                  const Text(
                                    '12',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'CHECKUPS',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withAlpha(153),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Empty expanded for spacing/balance if needed, or just let the checkups card take full width?
                          // The design shows cards side by side. Since Health Score is removed, 
                          // checkups can either be full width or half width. 
                          // Let's make it full width since it's the only one.
                          // Actually, a smaller card like "12 Checkups" looks weird full width.
                          // Let's keep it expanded and maybe add an empty space or center it? 
                          // No, typically you'd just have the one card.
                          // Let's stick to the previous layout structure but just one card.
                        ],
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('DISPLAY'),
                      const SizedBox(height: 16),

                      _buildGlassCard(
                        child: Column(
                          children: [
                            // Language
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSettingItemHeader(
                                  Icons.translate,
                                  const Color(0xFFFFAB40),
                                  'Language',
                                ),
                                Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(26),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildLanguageOption('EN', true),
                                      _buildLanguageOption('AM', false), // Amharic
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10, height: 1),
                            ),

                            // Text Size Dropdown
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSettingItemHeader(
                                  Icons.text_fields,
                                  const Color(0xFF6B9FFF),
                                  'Text Size',
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(13),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(26),
                                      width: 1,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedTextSize,
                                      dropdownColor: const Color(0xFF1E2432),
                                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      items: _textSizes.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedTextSize = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('PREFERENCES'),
                      const SizedBox(height: 16),

                      _buildGlassCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSettingItemHeader(
                              Icons.notifications_active,
                              const Color(0xFFFF6B6B),
                              'Notifications',
                              subtitle: 'Updates & Tips',
                            ),
                            Switch(
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFF00CBA9),
                              activeTrackColor: const Color(0xFF00CBA9).withAlpha(77),
                              inactiveThumbColor: Colors.white.withAlpha(179),
                              inactiveTrackColor: Colors.white.withAlpha(26),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('SUPPORT'),
                      const SizedBox(height: 16),

                      _buildGlassCard(
                        child: Column(
                          children: [
                            _buildSupportItem(Icons.help_outline, 'Help Center'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10, height: 1),
                            ),
                            _buildSupportItem(Icons.lock_outline, 'Privacy Policy'),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10, height: 1),
                            ),
                            _buildSupportItem(
                              Icons.logout, 
                              'Log Out', 
                              isDestructive: true,
                              iconColor: const Color(0xFFFF6B6B),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      
                      Center(
                        child: Text(
                          'BLACKSEED AI V0.1.0',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withAlpha(77),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.white.withAlpha(128),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withAlpha(20), // Slightly clearer integration
            Colors.white.withAlpha(10),
          ],
        ),
        border: Border.all(
          color: Colors.white.withAlpha(26),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle language switch
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? const Color(0xFF1A1D29) : Colors.white.withAlpha(179),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItemHeader(IconData icon, Color iconColor, String title, {String? subtitle}) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withAlpha(153),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSupportItem(IconData icon, String title, {bool isDestructive = false, Color? iconColor}) {
    return InkWell(
      onTap: () {
        // TODO: Handle tap
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.white.withAlpha(179),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDestructive ? const Color(0xFFFF6B6B) : Colors.white,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withAlpha(102),
            size: 20,
          ),
        ],
      ),
    );
  }
}
