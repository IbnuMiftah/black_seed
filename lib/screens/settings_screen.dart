import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import 'login_signup_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> _textSizes = ['Small', 'Medium', 'Large'];

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2432),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Log Out?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      await authProvider.signOut();
      await settingsProvider.clearSettings();
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open link'),
            backgroundColor: const Color(0xFFFF6B6B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

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
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    100,
                  ), // Extra bottom padding for nav bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('ACCOUNT'),
                      const SizedBox(height: 16),

                      // Profile Card
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          final user = authProvider.user;
                          return _buildGlassCard(
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
                                    child: user?.photoURL != null
                                        ? Image.network(
                                            user!.photoURL!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white.withAlpha(204),
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white.withAlpha(204),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              user?.displayName ?? user?.email?.split('@')[0] ?? 'User',
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
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
                                        user?.email ?? 'No email',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withAlpha(153),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Stats Row (Only Checkups as requested)
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${authProvider.checkupCount}',
                                        style: const TextStyle(
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
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('DISPLAY'),
                      const SizedBox(height: 16),

                      Consumer<SettingsProvider>(
                        builder: (context, settingsProvider, child) {
                          return _buildGlassCard(
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
                                          _buildLanguageOption(
                                            'EN',
                                            settingsProvider.language == 'EN',
                                            () => settingsProvider.setLanguage('EN'),
                                          ),
                                          _buildLanguageOption(
                                            'AM',
                                            settingsProvider.language == 'AM',
                                            () => settingsProvider.setLanguage('AM'),
                                          ), // Amharic
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
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
                                          value: settingsProvider.textSize,
                                          dropdownColor: const Color(0xFF1E2432),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
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
                                            if (newValue != null) {
                                              settingsProvider.setTextSize(newValue);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('PREFERENCES'),
                      const SizedBox(height: 16),

                      Consumer<SettingsProvider>(
                        builder: (context, settingsProvider, child) {
                          return _buildGlassCard(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSettingItemHeader(
                                      Icons.notifications_active,
                                      const Color(0xFFFF6B6B),
                                      'Notifications',
                                      subtitle: 'Updates & Tips',
                                    ),
                                    Switch(
                                      value: settingsProvider.notificationsEnabled,
                                      onChanged: (value) {
                                        settingsProvider.setNotificationsEnabled(value);
                                      },
                                      activeThumbColor: const Color(0xFF00CBA9),
                                      activeTrackColor: const Color(
                                        0xFF00CBA9,
                                      ).withAlpha(77),
                                      inactiveThumbColor: Colors.white.withAlpha(
                                        179,
                                      ),
                                      inactiveTrackColor: Colors.white.withAlpha(
                                        26,
                                      ),
                                    ),
                                  ],
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Divider(color: Colors.white10, height: 1),
                                ),

                                // Offline Mode Toggle
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSettingItemHeader(
                                      Icons.wifi_off_rounded,
                                      const Color(0xFF5FFFD7), // Mint
                                      'Offline Mode',
                                      subtitle: 'Save data',
                                    ),
                                    Switch(
                                      value: settingsProvider.offlineMode,
                                      onChanged: (value) {
                                        settingsProvider.setOfflineMode(value);
                                      },
                                      activeThumbColor: const Color(0xFF00CBA9),
                                      activeTrackColor: const Color(
                                        0xFF00CBA9,
                                      ).withAlpha(77),
                                      inactiveThumbColor: Colors.white.withAlpha(
                                        179,
                                      ),
                                      inactiveTrackColor: Colors.white.withAlpha(
                                        26,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                      _buildSectionHeader('SUPPORT'),
                      const SizedBox(height: 16),

                      _buildGlassCard(
                        child: Column(
                          children: [
                            _buildSupportItem(
                              Icons.help_outline,
                              'Help Center',
                              onTap: () => _launchUrl('https://support.google.com'),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10, height: 1),
                            ),
                            _buildSupportItem(
                              Icons.lock_outline,
                              'Privacy Policy',
                              onTap: () => _launchUrl('https://policies.google.com/privacy'),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Divider(color: Colors.white10, height: 1),
                            ),
                            _buildSupportItem(
                              Icons.logout,
                              'Log Out',
                              isDestructive: true,
                              iconColor: const Color(0xFFFF6B6B),
                              onTap: _handleLogout,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(20),
                  Colors.white.withAlpha(10),
                ],
              ),
              border: Border.all(color: Colors.white.withAlpha(26), width: 1),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
            color: isSelected
                ? const Color(0xFF1A1D29)
                : Colors.white.withAlpha(179),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItemHeader(
    IconData icon,
    Color iconColor,
    String title, {
    String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
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

  Widget _buildSupportItem(
    IconData icon,
    String title, {
    bool isDestructive = false,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
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
                    color: isDestructive
                        ? const Color(0xFFFF6B6B)
                        : Colors.white,
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
        ),
      ),
    );
  }
}
