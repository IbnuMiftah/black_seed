import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  // API key is loaded securely from .env file
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  
  // Conversation history for multi-turn chat
  final List<Map<String, dynamic>> _messages = [];
  
  // Health-focused system prompt
  static const String _systemPrompt = '''
You are BlackSeed, a friendly and knowledgeable AI health assistant. Your role is to:

1. Help users understand their symptoms in a clear, empathetic way
2. Provide general health information and first-aid guidance
3. Always remind users that you are NOT a replacement for professional medical advice
4. Encourage users to seek professional help for serious symptoms
5. Be supportive, calm, and reassuring in your responses
6. Ask clarifying questions to better understand the user's situation
7. Provide actionable tips when appropriate (rest, hydration, etc.)

IMPORTANT SAFETY RULES:
- Never diagnose conditions definitively
- Always recommend consulting a healthcare professional for persistent or severe symptoms
- For emergency symptoms (chest pain, difficulty breathing, severe bleeding, etc.), immediately advise calling emergency services
- Be culturally sensitive and consider that users may be from Ethiopia or other regions

Keep responses concise but helpful. Use simple language that's easy to understand.
''';

  GeminiService() {
    final key = _apiKey;
    print('Groq API Key loaded: ${key.isEmpty ? "EMPTY!" : "***${key.substring(key.length > 8 ? key.length - 8 : 0)}"}');
    
    if (key.isEmpty) {
      print('WARNING: No API key found! Make sure .env file contains GROQ_API_KEY');
    }
  }

  // Send a message and get a response using Groq API
  Future<String> sendMessage(String message) async {
    final apiKey = _apiKey;
    
    if (apiKey.isEmpty) {
      return 'API key not configured. Please check your .env file for GROQ_API_KEY.';
    }
    
    // Groq API endpoint (OpenAI-compatible)
    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    
    // Add user message to history
    _messages.add({
      "role": "user",
      "content": message
    });
    
    // Build messages array with system prompt
    final allMessages = [
      {"role": "system", "content": _systemPrompt},
      ..._messages
    ];
    
    // Prepare request body
    final requestBody = {
      "model": "llama-3.3-70b-versatile",  // Fast and capable model
      "messages": allMessages,
      "temperature": 0.7,
      "max_tokens": 1024,
    };
    
    int maxRetries = 3;
    int retryDelay = 2;
    
    for (int i = 0; i < maxRetries; i++) {
      try {
        print('Sending message to Groq: $message (Attempt ${i + 1})');
        
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode(requestBody),
        );
        
        print('Response status: ${response.statusCode}');
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          // Extract the response text
          if (data['choices'] != null &&
              data['choices'].isNotEmpty &&
              data['choices'][0]['message'] != null &&
              data['choices'][0]['message']['content'] != null) {
            
            final responseText = data['choices'][0]['message']['content'];
            
            // Add assistant response to history
            _messages.add({
              "role": "assistant",
              "content": responseText
            });
            
            return responseText;
          } else {
            return "Sorry, I couldn't get a clear response.";
          }
        } else {
          print('Error response: ${response.body}');
          
          // Check for rate limit errors
          if (response.statusCode == 429) {
            if (i < maxRetries - 1) {
              print('Rate limit hit. Retrying in $retryDelay seconds...');
              await Future.delayed(Duration(seconds: retryDelay));
              retryDelay *= 2;
              _messages.removeLast(); // Remove failed message
              continue;
            }
            return 'API rate limit exceeded. Please wait a moment and try again.';
          }
          
          return 'Error: ${response.statusCode} - Could not get response from AI.';
        }
      } catch (e, stackTrace) {
        print('Groq API Error (Attempt ${i + 1}): $e');
        print('Stack trace: $stackTrace');
        
        if (i < maxRetries - 1) {
          await Future.delayed(Duration(seconds: retryDelay));
          retryDelay *= 2;
          continue;
        }
        
        return 'Connection error. Please check your internet and try again.';
      }
    }
    
    return 'An unexpected error occurred. Please try again.';
  }

  // Start a new chat session (clears history)
  void startNewChat() {
    _messages.clear();
  }
}
