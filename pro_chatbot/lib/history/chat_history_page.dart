import 'package:flutter/material.dart';
import 'package:pro_chatbot/api/api_services.dart';
import 'package:provider/provider.dart';
import '/models/conversation.dart';
import '/api/conversation_service.dart';
import '/api/user_provider.dart';

/// Temporary main so this file can be run directly during debugging.
/// Remove or comment out this main when integrating into the full app.
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: _TestHomePage(), // test page with a navigateur button
  ));
}

/// Page de test temporaire pour tester la navigation
class _TestHomePage extends StatelessWidget {
  const _TestHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Navigation'),
        backgroundColor: const Color(0xFF4242BD),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4242BD),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            'Ouvrir Chat geschiedenis',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Chat history page designed to match the provided mockup.
class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ConversationService _conversationService = ConversationService();

  List<Conversation> _allConversations = [];
  List<Conversation> _filteredConversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterChats);
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterChats);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      if (currentUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final conversations =
          await _conversationService.getUserConversations(currentUser.id);

      setState(() {
        _allConversations = conversations;
        _filteredConversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading conversations: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij laden van gesprekken: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = List.from(_allConversations);
      } else {
        _filteredConversations = _allConversations
            .where((conv) =>
                conv.title.toLowerCase().contains(query) ||
                _formatDate(conv.createdAt).toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onSearchIconTap() {
    _searchFocusNode.requestFocus();
  }

  Future<void> _openConversation(int index) async {
    if (index < 0 || index >= _filteredConversations.length) return;

    final conversation = _filteredConversations[index];
    ApiService().setConversationId(conversation.id);
    // Navigate back to chat with this conversation loaded
    Navigator.pop(context, conversation);
  }

  Future<void> _deleteChat(int index) async {
    // Check bounds before accessing
    if (index < 0 || index >= _filteredConversations.length) {
      print(
          'Error: Invalid index $index for list of length ${_filteredConversations.length}');
      return;
    }

    final conversation = _filteredConversations[index];

    try {
      await _conversationService.deleteConversation(conversation.id);

      setState(() {
        _allConversations.removeWhere((conv) => conv.id == conversation.id);
        _filteredConversations
            .removeWhere((conv) => conv.id == conversation.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat verwijderd'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error deleting conversation: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij verwijderen: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Vandaag';
    } else if (difference.inDays == 1) {
      return 'Gisteren';
    } else if (difference.inDays < 7) {
      // Return day of week in Dutch
      const days = [
        'Maandag',
        'Dinsdag',
        'Woensdag',
        'Donderdag',
        'Vrijdag',
        'Zaterdag',
        'Zondag'
      ];
      return days[date.weekday - 1];
    } else {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }

  void _showDeleteMenu(BuildContext context, int index, Offset buttonPosition) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      color: Colors.transparent,
      elevation: 0,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx - 150,
        buttonPosition.dy + 20,
        overlay.size.width - buttonPosition.dx - 50,
        overlay.size.height - buttonPosition.dy,
      ),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4444),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Chat verwijderen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Future.delayed(Duration.zero, () => _deleteChat(index));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color deepBlue = Color(0xFF4242BD);
    const Color cardGrey = Color(0xFFD9D9D9);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Chat history list scrollable (starts from top, goes under title)
              Positioned.fill(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: deepBlue,
                        ),
                      )
                    : _filteredConversations.isEmpty
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 140.0, left: 40.0, right: 40.0),
                              child: Text(
                                _allConversations.isEmpty
                                    ? 'Geen gesprekken\nStart een chat om te beginnen!'
                                    : 'Geen chats gevonden',
                                style: TextStyle(
                                  color: deepBlue.withOpacity(0.7),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              scrollbars: false,
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                left: 18.0,
                                right: 18.0,
                                top: 120.0, // Space for title at top
                                bottom:
                                    200.0, // Space for search bar + return button
                              ),
                              itemCount: _filteredConversations.length,
                              itemBuilder: (context, index) {
                                final conversation =
                                    _filteredConversations[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: _buildChatCard(
                                    index,
                                    conversation.title,
                                    _formatDate(conversation.createdAt),
                                    cardGrey,
                                    deepBlue,
                                  ),
                                );
                              },
                            ),
                          ),
              ),

              // Title positioned at top (fixed, list scrolls behind it)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.transparent,
                  child: const Text(
                    'Chat geschiedenis',
                    style: TextStyle(
                      color: deepBlue,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Search bar positioned above the list (fixed at bottom of content area)
              Positioned(
                left: 0,
                right: 0,
                bottom: 120, // Above return button
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Een chat zoeken',
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 18),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _onSearchIconTap,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/search.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Return button - raw/brut without styling
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('Return button tapped!');
                      if (Navigator.canPop(context)) {
                        print('Navigating back...');
                        // Return a special value to indicate starting fresh
                        Navigator.pop(context, 'start_new_chat');
                      } else {
                        print('Cannot pop - no previous route');
                      }
                    },
                    child: Container(
                      width: 76,
                      height: 76,
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/return.png',
                        width: 76,
                        height: 76,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatCard(
      int index, String title, String date, Color cardGrey, Color deepBlue) {
    return GestureDetector(
      onTap: () => _openConversation(index),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: cardGrey,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: deepBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Builder(
                builder: (BuildContext buttonContext) {
                  return GestureDetector(
                    onTap: () {
                      final RenderBox? button =
                          buttonContext.findRenderObject() as RenderBox?;
                      if (button != null) {
                        final Offset buttonPosition =
                            button.localToGlobal(Offset.zero);
                        _showDeleteMenu(context, index, buttonPosition);
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.more_vert, color: deepBlue, size: 24),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
