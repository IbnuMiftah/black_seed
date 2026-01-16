import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set user ID for chat provider to enable database sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      if (authProvider.user != null) {
        chatProvider.setUserId(authProvider.user!.uid);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        // Check again inside the callback since scroll view might be disposed
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
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
              const Color(0xFF1A1D29),
              const Color(0xFF0F1419),
              const Color(0xFF1E2432),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Messages
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: chatProvider.messages.length +
                          (chatProvider.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chatProvider.messages.length &&
                            chatProvider.isTyping) {
                          return _buildTypingIndicator();
                        }
                        final message = chatProvider.messages[index];
                        return _buildMessageBubble(message);
                      },
                    );
                  },
                ),
              ),

              // Input field
              _buildInputField(),

              // Spacing for Bottom Navigation Bar
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                  color: const Color(0xFF00CBA9).withAlpha(102),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BlackSeed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: chatProvider.isTyping
                                ? const Color(0xFFFFAB40)
                                : const Color(0xFF00CBA9),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          chatProvider.isTyping ? 'Typing...' : 'Online',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: chatProvider.isTyping
                                ? const Color(0xFFFFAB40).withAlpha(230)
                                : const Color(0xFF00CBA9).withAlpha(230),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          // New chat button
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E2432),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text(
                    'Start New Chat?',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'This will clear your current conversation.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .startNewConversation();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'New Chat',
                        style: TextStyle(color: Color(0xFF00CBA9)),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.add_comment_outlined,
              color: Colors.white.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF00CBA9).withAlpha(230),
                  const Color(0xFF5FFFD7).withAlpha(230),
                ],
              ),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Typing dots
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(26),
                  Colors.white.withAlpha(13),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.white.withAlpha(26),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00CBA9).withAlpha((128 + (127 * value)).round()),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final textScale = _getTextScale(settingsProvider.textSize);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                // AI Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF00CBA9).withAlpha(230),
                        const Color(0xFF5FFFD7).withAlpha(230),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Message bubble
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isUser
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1E2432), Color(0xFF1A1D29)],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withAlpha(26),
                              Colors.white.withAlpha(13),
                            ],
                          ),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: message.isUser
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: message.isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                    border: Border.all(
                      color: message.isUser
                          ? const Color(0xFF00CBA9).withAlpha(51)
                          : Colors.white.withAlpha(26),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15 * textScale,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (message.isUser) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12 * textScale,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withAlpha(102),
                ),
              ),
            ),
          ],
        ],
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Microphone button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withAlpha(26),
                  Colors.white.withAlpha(13),
                ],
              ),
              border: Border.all(color: Colors.white.withAlpha(51), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Handle voice input (not implemented yet)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Voice input coming soon!'),
                      backgroundColor: const Color(0xFF00CBA9),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                customBorder: const CircleBorder(),
                child: const Center(
                  child: Icon(Icons.mic, color: Color(0xFF00CBA9), size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text field
          Expanded(
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
                border: Border.all(color: Colors.white.withAlpha(51), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Describe your symptoms',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withAlpha(102),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00CBA9), Color(0xFF5FFFD7)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00CBA9).withAlpha(128),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: chatProvider.isTyping ? null : _sendMessage,
                    customBorder: const CircleBorder(),
                    child: Center(
                      child: chatProvider.isTyping
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1A1D29),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Color(0xFF1A1D29),
                              size: 22,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
