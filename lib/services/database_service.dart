import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create or update user profile
  Future<void> upsertProfile({
    required String odUserId,
    required String email,
    String? fullName,
  }) async {
    print('Attempting to upsert profile for user: $odUserId');
    try {
      await _supabase.from('profiles').upsert({
        'id': odUserId,
        'email': email,
        'full_name': fullName,
        'is_pro': false,
      });
      print('Profile upsert SUCCESS for user: $odUserId');
    } catch (e) {
      print('Profile upsert FAILED: $e');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getProfile(String odUserId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', odUserId)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  // Save a chat message
  Future<void> saveChatMessage({
    required String odUserId,
    required String message,
    required bool isUserMessage,
  }) async {
    print('Attempting to save chat message for user: $odUserId');
    try {
      await _supabase.from('chat_history').insert({
        'user_id': odUserId,
        'message': message,
        'is_user_message': isUserMessage,
      });
      print('Chat message save SUCCESS');
    } catch (e) {
      print('Save chat message FAILED: $e');
    }
  }

  // Load chat history for user
  Future<List<Map<String, dynamic>>> loadChatHistory(String odUserId) async {
    try {
      final response = await _supabase
          .from('chat_history')
          .select()
          .eq('user_id', odUserId)
          .order('timestamp', ascending: true)
          .limit(100); // Limit to last 100 messages
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Load chat history error: $e');
      return [];
    }
  }

  // Clear chat history for user
  Future<void> clearChatHistory(String odUserId) async {
    try {
      await _supabase
          .from('chat_history')
          .delete()
          .eq('user_id', odUserId);
    } catch (e) {
      print('Clear chat history error: $e');
    }
  }

  // Get chat message count (for checkups stat)
  Future<int> getChatCount(String odUserId) async {
    try {
      final response = await _supabase
          .from('chat_history')
          .select('id')
          .eq('user_id', odUserId)
          .eq('is_user_message', true);
      return (response as List).length;
    } catch (e) {
      print('Get chat count error: $e');
      return 0;
    }
  }
}
