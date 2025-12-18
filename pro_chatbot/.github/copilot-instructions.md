# Luminara AI - Copilot Instructions

## Project Overview
Flutter-based educational chatbot platform ("Luminara AI") targeting Windows desktop deployment via MSIX. The app connects to a backend at `https://chatbot.duonra.nl` and supports role-based access (admin, teacher, student) with multi-modal chat interactions.

## Architecture

### State Management
- **Provider pattern** throughout: `ThemeManager` and `UserProvider` are app-wide providers initialized in `main.dart`
- Access providers with: `Provider.of<ThemeManager>(context)` or `Provider.of<UserProvider>(context, listen: false)`
- `ChatController` extends `ChangeNotifier` for chat-specific state (messages, typing indicators, TTS state)

### Key Components
- **lib/api/api_services.dart**: Singleton `ApiService` with conversation state tracking
  - Call `ApiService().setUserId(id)` after login
  - Call `ApiService().resetConversation()` to start new chats
  - Maintains `_conversationId` internally for multi-turn conversations
- **lib/models/**: Domain models with `.fromJson()` factories (User, School, Conversation, etc.)
- **lib/navigation/navigation_page.dart**: Main hub after login with role-based navigation buttons
- **lib/chat/**: Chat feature with multi-modal support (text, voice, files, images)

### Routing Pattern
Manual navigation via `Navigator.push/pushReplacement` - no named routes or go_router. Pages are constructed inline:
```dart
Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
```

### Role-Based Access
Check user role via `UserProvider`:
```dart
final userProvider = Provider.of<UserProvider>(context, listen: false);
if (userProvider.hasRole(Role.admin)) {
  // Admin-only logic
}
```
Roles: `Role.admin`, `Role.teacher`, `Role.student` (enum in `lib/models/user.dart`)

## Design System

### Theme Management
`ThemeManager` provides:
- **Color-blind mode**: Toggle switches from default purple (`0xFF6464FF`) to IBM Color Blind Safe Palette
- **Dark/light mode**: `isWhiteSelected` boolean (white=light, black87=dark)
- **Dynamic container colors**: Use `getContainerColor(index)` for consistent palette cycling

Example usage:
```dart
final themeManager = Provider.of<ThemeManager>(context);
Container(
  color: themeManager.getContainerColor(0),
  child: Text('Title', style: TextStyle(color: themeManager.subtitleTextColor)),
)
```

### UI Patterns
- **WaveBackgroundLayout**: Custom gradient wave widget wrapping most pages (see `wave_background_layout.dart`)
- **Pressed state**: Pages use `_pressedButton` string for button press animations
- **Scroll + ConstrainedBox**: Common pattern for scrollable pages with min-height constraint

## Development Workflows

### Running the App
```bash
flutter run -d windows  # Windows desktop
flutter run -d chrome   # Web preview
```

### Building MSIX Package
Configured in `pubspec.yaml` under `msix_config`:
```bash
flutter pub run msix:create
```
Package name: "Luminara AI" with microphone and internetClient capabilities.

### Testing Multi-Modal Chat
Shell script exists: `test_chat_features.sh` - review for API testing patterns.

### Dependencies
- `provider: ^6.1.2` - State management
- `http: ^1.5.0` - API calls
- `flutter_tts: ^4.2.3` - Text-to-speech for chat responses
- `speech_to_text: ^7.0.0` - Voice input
- `file_picker: ^8.1.4`, `image_picker: ^1.1.2`, `record: ^6.0.0` - Multi-modal inputs
- `flutter_markdown: ^0.7.4+1` - Rendering AI responses

## Code Conventions

### Async/Await Patterns
Always check `mounted` before `setState` after async operations:
```dart
Future<void> _handleLogin() async {
  // ... async work ...
  if (!mounted) return;
  setState(() => _errorMessage = error);
}
```

### Error Handling
Strip "Exception: " prefix from error messages for user display:
```dart
setState(() {
  _errorMessage = e.toString().replaceFirst('Exception: ', '');
});
```

### API Response Structure
Backend returns JSON with:
- Chat: `{response: string, conversation_id?: string}`
- Login: User JSON with nested school object
- Expected status codes: 200 (success), 400 (validation), 401 (auth), 500 (server error)

### File Organization
- **Feature folders**: Each feature (chat/, settings/, admindashboard/, training/) contains all related pages
- **Backup files**: `Backup admin.dart` suggests iterative development - check for similar backup files
- **Platform-specific**: Use `platform_helper.dart` for cross-platform checks (web vs desktop)

## Common Tasks

### Adding a New Page
1. Create in appropriate feature folder (e.g., `lib/settings/new_page.dart`)
2. Wrap in `WaveBackgroundLayout` with `themeManager.backgroundColor`
3. Add navigation button in parent page with `_pressedButton` state
4. Use `Provider.of<ThemeManager>(context)` for theme colors

### Extending API Service
Add methods to `lib/api/api_services.dart` singleton. Pattern:
```dart
Future<ReturnType> methodName(params) async {
  final url = Uri.parse('$baseUrl/api/endpoint');
  final response = await _client.post(url, ...);
  if (response.statusCode == 200) {
    return ReturnType.fromJson(jsonDecode(response.body));
  }
  throw Exception('Error message');
}
```

### Adding Multi-Modal Input
See `lib/chat/chat_page.dart` methods:
- `_handleFilePicker()` - Documents
- `_handleGalleryPicker()` - Images from gallery
- `_handleCamera()` - Take photo
- `_handleMicrophone()` - Voice recording
All use `attachment_service.dart` for processing.

## Known Patterns

### Conversation Management
`ApiService` maintains conversation state automatically:
- First message in conversation: no `conversation_id` sent
- Backend returns `conversation_id` in response
- Subsequent messages include this ID for context
- Call `resetConversation()` to clear state for new chat

### Help Request System
Separate service: `lib/api/help_request_service.dart` for student-teacher Q&A distinct from AI chat.

### Dutch Language
UI text is in Dutch. Error messages, labels, and navigation use Dutch terms (e.g., "Docent" for teacher).
