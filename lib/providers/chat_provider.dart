import 'package:flutter/foundation.dart';
import '../services/gemini_service.dart';
import '../services/database_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      text: map['message'] ?? '',
      isUser: map['is_user_message'] ?? true,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

class ChatProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final DatabaseService _databaseService = DatabaseService();
  
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _error;
  String? _currentUserId;
  bool _historyLoaded = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  String? get error => _error;

  ChatProvider() {
    // Add initial greeting message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: "Good day! I'm BlackSeed, your personal health assistant. How are you feeling today? Feel free to describe any symptoms or health concerns you have.",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  // Set the current user ID for database operations
  void setUserId(String? userId) {
    _currentUserId = userId;
    if (userId != null && !_historyLoaded) {
      loadChatHistory();
    }
  }

  // Load chat history from Supabase
  Future<void> loadChatHistory() async {
    if (_currentUserId == null) return;

    try {
      final history = await _databaseService.loadChatHistory(_currentUserId!);
      if (history.isNotEmpty) {
        _messages.clear();
        for (final item in history) {
          _messages.add(ChatMessage.fromMap(item));
        }
        // Add welcome message if no messages
        if (_messages.isEmpty) {
          _addWelcomeMessage();
        }
        _historyLoaded = true;
        notifyListeners();
      }
    } catch (e) {
      print('Failed to load chat history: $e');
    }
  }

  // Send a message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _error = null;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    // Save user message to database (fire and forget - don't block UI)
    if (_currentUserId != null) {
      _databaseService.saveChatMessage(
        odUserId: _currentUserId!,
        message: text,
        isUserMessage: true,
      ).catchError((e) {
        // Silently log - don't break the chat
        print('Background save failed: $e');
      });
    }

    // Show typing indicator
    _isTyping = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _geminiService.sendMessage(text);

      // Add AI message
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMessage);

      // Save AI message to database (fire and forget)
      if (_currentUserId != null) {
        _databaseService.saveChatMessage(
          odUserId: _currentUserId!,
          message: response,
          isUserMessage: false,
        ).catchError((e) {
          print('Background save failed: $e');
        });
      }
    } catch (e) {
      _error = 'Failed to get response. Please try again.';
      // Add error message
      _messages.add(ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        text: "I'm sorry, I'm having trouble connecting right now. Please check your internet connection and try again.",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    _isTyping = false;
    notifyListeners();
  }

  // Start a new conversation
  Future<void> startNewConversation() async {
    // Clear from database if user is logged in
    if (_currentUserId != null) {
      await _databaseService.clearChatHistory(_currentUserId!);
    }
    
    _messages.clear();
    _geminiService.startNewChat();
    _addWelcomeMessage();
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get message count for stats
  Future<int> getMessageCount() async {
    if (_currentUserId == null) return 0;
    return await _databaseService.getChatCount(_currentUserId!);
  }
}
