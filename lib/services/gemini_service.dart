import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAE2fl_dq_TZs_64fHavmf-5wYawFslDgE';
  
  late final GenerativeModel _model;
  ChatSession? _chat;
  
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
    _initModel();
  }

  void _initModel() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      systemInstruction: Content.text(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    _chat = _model.startChat();
  }

  // Send a message and get a response
  Future<String> sendMessage(String message) async {
    int maxRetries = 3;
    int retryDelay = 2; // seconds

    for (int i = 0; i < maxRetries; i++) {
      try {
        // Ensure chat is initialized
        _chat ??= _model.startChat();
        
        print('Sending message to Gemini: $message (Attempt ${i + 1})');
        final response = await _chat!.sendMessage(Content.text(message));
        print('Received response from Gemini');
        
        final text = response.text;
        if (text == null || text.isEmpty) {
          return 'I apologize, but I could not generate a response. Please try again.';
        }
        return text;
      } catch (e, stackTrace) {
        print('Gemini API Error (Attempt ${i + 1}): $e');
        
        // Check for quota/rate limit errors
        if (e.toString().contains('Quota exceeded') || e.toString().contains('429')) {
             if (i < maxRetries - 1) {
                print('Rate limit hit. Retrying in $retryDelay seconds...');
                await Future.delayed(Duration(seconds: retryDelay));
                retryDelay *= 2; // Exponential backoff
                continue;
             }
        }

        print('Stack trace: $stackTrace');
        if (i == maxRetries - 1) {
             return 'I\'m currently overloaded with requests. Please wait a moment and try again. (Quota Exceeded)';
        }
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }

  // Start a new chat session (clears history)
  void startNewChat() {
    _chat = _model.startChat();
  }

  // Get chat history
  List<Content> get history => _chat?.history.toList() ?? [];
}
