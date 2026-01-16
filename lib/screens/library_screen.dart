import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../services/database_service.dart';

class LibraryScreen extends StatefulWidget {
  final Function(int)? onTabChange;

  const LibraryScreen({super.key, this.onTabChange});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['All Topics', 'Symptoms', 'First Aid'];
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _chatHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.uid;
    
    if (userId != null) {
      final history = await _databaseService.loadChatHistory(userId);
      if (mounted) {
        setState(() {
          _chatHistory = history;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Group chat history into sessions (conversations separated by time gaps)
  List<Map<String, dynamic>> _getSessionSummaries() {
    if (_chatHistory.isEmpty) return [];
    
    List<Map<String, dynamic>> sessions = [];
    List<Map<String, dynamic>> currentSession = [];
    DateTime? lastMessageTime;
    
    for (var message in _chatHistory) {
      // Check for explicit session delimiter
      if (message['message'] == '[__SESSION_BREAK__]') {
        if (currentSession.isNotEmpty) {
          sessions.add(_createSessionSummary(currentSession));
          currentSession = [];
        }
        lastMessageTime = null;
        continue;
      }

      final timestamp = DateTime.tryParse(message['timestamp'] ?? '');
      if (timestamp == null) continue;
      
      // If more than 1 hour gap, start a new session
      if (lastMessageTime != null && 
          timestamp.difference(lastMessageTime).inHours > 1) {
        if (currentSession.isNotEmpty) {
          sessions.add(_createSessionSummary(currentSession));
        }
        currentSession = [];
      }
      
      currentSession.add(message);
      lastMessageTime = timestamp;
    }
    
    // Add the last session
    if (currentSession.isNotEmpty) {
      sessions.add(_createSessionSummary(currentSession));
    }
    
    // Return most recent sessions first
    return sessions.reversed.take(10).toList();
  }

  Map<String, dynamic> _createSessionSummary(List<Map<String, dynamic>> messages) {
    // Get first user message as the title
    String title = 'Chat Session';
    String preview = '';
    DateTime? timestamp;
    
    for (var msg in messages) {
      if (msg['is_user_message'] == true && title == 'Chat Session') {
        final userMsg = msg['message'] as String? ?? '';
        title = userMsg.length > 30 ? '${userMsg.substring(0, 30)}...' : userMsg;
      }
      if (msg['is_user_message'] == false && preview.isEmpty) {
        final aiMsg = msg['message'] as String? ?? '';
        preview = aiMsg.length > 60 ? '${aiMsg.substring(0, 60)}...' : aiMsg;
      }
      if (msg['timestamp'] != null) {
        timestamp = DateTime.tryParse(msg['timestamp']);
      }
    }
    
    return {
      'title': title,
      'preview': preview,
      'timestamp': timestamp,
      'messageCount': messages.length,
    };
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} week${difference.inDays >= 14 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final textScale = _getTextScale(settingsProvider.textSize);
    
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          'Library',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24 * textScale,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'BlackSeed AI',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13 * textScale,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF00CBA9).withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(26),
                        Colors.white.withAlpha(13),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withAlpha(51),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Icon(
                            Icons.search,
                            color: Colors.white.withAlpha(179),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15 * textScale,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search conditions, symptoms...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 15 * textScale,
                                  color: Colors.white.withAlpha(128),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: List.generate(
                    _tabs.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index < _tabs.length - 1 ? 12 : 0,
                      ),
                      child: _buildCategoryTab(
                        _tabs[index],
                        index == _selectedTabIndex,
                        () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        textScale,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Popular Articles Section
                      Text(
                        'Popular Articles',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20 * textScale,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Horizontal scrolling article cards
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildArticleCard(
                              title: 'Indigestion',
                              subtitle: 'Stomach & Digestion',
                              description:
                                  'Discomfort in your upper abdomen. Guides on triggers, relief postures, and safe OTC...',
                              isOffline: true,
                              textScale: textScale,
                            ),
                            const SizedBox(width: 16),
                            _buildArticleCard(
                              title: 'Headache',
                              subtitle: 'Neurology & Pain',
                              description:
                                  'Identification of tension, migraine, or cluster headaches with pressure point relief...',
                              isOffline: true,
                              textScale: textScale,
                            ),
                            const SizedBox(width: 16),
                            _buildArticleCard(
                              title: 'Cuts & Scrapes',
                              subtitle: 'First Aid',
                              description:
                                  'Step-by-step cleaning and dressing instructions to prevent infection for minor...',
                              isOffline: true,
                              textScale: textScale,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Saved Sessions Section - Now with actual data
                      Text(
                        'Saved Sessions',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20 * textScale,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_isLoading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(
                              color: const Color(0xFF00CBA9),
                            ),
                          ),
                        )
                      else if (_getSessionSummaries().isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white.withAlpha(20), Colors.white.withAlpha(10)],
                            ),
                            border: Border.all(color: Colors.white.withAlpha(26), width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white.withAlpha(128),
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No chat history yet',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16 * textScale,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Start a conversation to see your saved sessions here',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13 * textScale,
                                        color: Colors.white.withAlpha(128),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...(_getSessionSummaries().map((session) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildSavedSessionCard(
                            session['title'] ?? 'Chat Session',
                            _formatTimestamp(session['timestamp']),
                            session['preview'] ?? '',
                            session['messageCount'] ?? 0,
                            textScale,
                            () {
                              // Navigate to Chat tab (index 1)
                              if (widget.onTabChange != null) {
                                widget.onTabChange!(1);
                              }
                            },
                          ),
                        ))),

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

  double _getTextScale(String textSize) {
    switch (textSize) {
      case 'Small':
        return 0.85;
      case 'Large':
        return 1.15;
      case 'Medium':
      default:
        return 1.0;
    }
  }

  Widget _buildCategoryTab(String label, bool isSelected, VoidCallback onTap, double textScale) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected
              ? const Color(0xFF00CBA9)
              : Colors.white.withAlpha(13),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withAlpha(26),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00CBA9).withAlpha(102),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14 * textScale,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF1A1D29)
                : Colors.white.withAlpha(204),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String subtitle,
    required String description,
    required bool isOffline,
    required double textScale,
  }) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(26), Colors.white.withAlpha(13)],
        ),
        border: Border.all(color: Colors.white.withAlpha(38), width: 1),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18 * textScale,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13 * textScale,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF00CBA9).withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withAlpha(128),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14 * textScale,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(179),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isOffline) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.offline_pin,
                        color: const Color(0xFF00CBA9).withAlpha(179),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AVAILABLE OFFLINE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11 * textScale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00CBA9).withAlpha(179),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedSessionCard(String title, String timestamp, String preview, int messageCount, double textScale, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withAlpha(20), Colors.white.withAlpha(10)],
        ),
        border: Border.all(color: Colors.white.withAlpha(26), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16 * textScale,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                timestamp,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12 * textScale,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withAlpha(128),
                                ),
                              ),
                              if (messageCount > 0) ...[
                                Text(
                                  ' • ',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(128),
                                  ),
                                ),
                                Text(
                                  '$messageCount messages',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12 * textScale,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF00CBA9).withAlpha(179),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withAlpha(102),
                      size: 20,
                    ),
                  ],
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    preview,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13 * textScale,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withAlpha(128),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
