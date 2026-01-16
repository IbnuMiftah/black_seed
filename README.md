# BlackSeed: AI-Powered Personal Health Companion

## 📖 Project Overview & Business Problem & Context (Ethiopia)
In Ethiopia, the ratio of physicians to people is critically low—approximately **1:10,000**—leaving millions with limited access to professional medical advice. This gap forces many to rely on unverified advice, rumors, or fragmented internet searches that often lead to anxiety or misinformation.

**BlackSeed** addresses this urgent need by acting as a first-line digital health companion. It democratizes access to health information, bridging the gap between the shortage of medical professionals and the growing demand for reliable health guidance. By providing a calm, intelligent, and context-aware assistant, BlackSeed helps users navigate their health concerns with confidence before seeking professional care.

This solution is not just about technology; it's about solving the "continuity problem" in a resource-constrained setting. Instead of one-off searches, BlackSeed maintains a history of your interactions, offering a holistic view of your health journey—essential for a population where consistent medical records are often unavailable.

---

## 🚀 Key Features

### 1. Intelligent Health Chat
- Powered by **Groq API**, delivering lightning-fast, high-quality responses tailored for health and wellness.
- **Context-Aware**: The AI remembers the conversation flow, allowing for meaningful follow-up questions.
- **Typing Indicators & Natural Feel**: Designed to mimic a real consultation experience, crucial for building trust.

### 2. Smart Library & Session Management
- **Automatic Grouping**: Chat history is automatically grouped into "Sessions" based on time gaps, making it easy to find past conversations.
- **Contextual Resume**: Tapping on any saved session in the Library instantly restores that specific conversation history in the chat interface, preserving the context of that interaction.
- **Explicit Session Delimiters**: Simply starting a "New Chat" logically separates your timeline, ensuring your different health queries remain distinct and organized.

### 3. User Experience & Design
- **Glassmorphism UI**: A modern, premium aesthetic using blur effects, gradients, and dark mode for visual comfort.
- **Accessibility**: Global text scaling limits ensure the app remains usable for visually impaired users.
- **Seamless Navigation**: Smooth transitions between Home, Chat, Library, and Settings without losing state.

### 4. Robust Backend
- **Supabase Integration**: Efficient storage of user profiles and chat history with real-time capabilities.
- **Authentication**: Secure login and signup flows (Email/Password & Google Sign-In) via Firebase/Supabase.

---

## 🛠 Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend / Database**: Supabase (PostgreSQL)
- **AI Engine**: Groq API (High-performance LLM inference)
- **Authentication**: Firebase Auth & Supabase Auth
- **State Management**: Provider

---

## 🚧 Future Roadmap & Known Limitations
*This project is an evolving prototype. Several features are planned but were not implemented in this version due to time constraints and technical research requirements.*

### 1. Offline Mode & Security
- **Goal**: Allow users to access their health history without an internet connection.
- **Current Status**: Not implemented.
- **Reason**: Requires robust **local file encryption** to ensure sensitive health data stored on the device is secure. We are currently researching the best practices for secure local storage in Flutter.

### 2. Voice Interaction
- **Goal**: Hands-free usage via Voice-to-Text (input) and Text-to-Speech (output).
- **Current Status**: Not implemented.
- **Reason**: Implementation of high-quality, continuous voice recognition and natural-sounding synthesis requires further integration with native APIs or cloud services.

### 3. Advanced AI Capabilities (RAG)
- **Goal**: Reduce hallucinations and provide sourced medical answers.
- **Current Status**: Standard LLM responses.
- **Reason**: Implementing **Vector Search** and **RAG (Retrieval-Augmented Generation)** requires setting up a vector database and embedding pipelines, which was out of scope for the initial sprint.

### 4. Multilingual Support
- **Goal**: Full app localization (e.g., English & Amharic).
- **Current Status**: UI scaffolding exists (language toggle), but content is not fully translated.
- **Reason**: Requires a comprehensive localization strategy for both static string resources and dynamic AI responses.

### 5. Verified Health Articles
- **Goal**: A curated feed of medical articles in the Library.
- **Current Status**: Placeholder / Static content.
- **Reason**: We are actively seeking a reliable, API-first medical content provider to serve verified articles.

### 6. Granular Notifications
- **Goal**: Custom alerts for checkups, article updates, and medication reminders.
- **Current Status**: Basic toggle implemented; logic pending.
- **Reason**: Dependent on the implementation of the Articles and Checkup Scheduler features.

---

## 📦 Getting Started

1. **Clone the repository**
2. **Setup Environment**:
   - Create a `.env` file in the root.
   - Add your keys: `Groq_API_Key`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`.
3. **Run the App**:
   ```bash
   flutter pub get
   flutter run
   ```

---
*Developed with ❤️ by Abdurahman Miftah*
