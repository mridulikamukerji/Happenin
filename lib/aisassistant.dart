import 'package:flutter/material.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  // ✅ List of conversations, each conversation = list of messages
  final List<List<Map<String, String>>> _conversations = [];
  int _currentConversationIndex = -1; // -1 means no conversation open

  // Sidebar controller
  late AnimationController _sidebarController;
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _sidebarController.forward();
      } else {
        _sidebarController.reverse();
      }
    });
  }

  void _startNewConversation() {
    setState(() {
      _conversations.insert(0, []); // ✅ insert at top
      _currentConversationIndex = 0;
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    if (_currentConversationIndex == -1) {
      _startNewConversation();
    }

    final userMessage = _controller.text.trim();
    setState(() {
      _conversations[_currentConversationIndex]
          .add({"role": "user", "text": userMessage});

      // ✅ Move updated conversation to top
      final updated = _conversations.removeAt(_currentConversationIndex);
      _conversations.insert(0, updated);
      _currentConversationIndex = 0;
    });

    _controller.clear();

    // Mock AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_currentConversationIndex == -1) return;
      setState(() {
        _conversations[_currentConversationIndex].add({
          "role": "ai",
          "text": "You said: \"$userMessage\". I'm here to assist you!"
        });

        // ✅ Move updated conversation again to top
        final updated = _conversations.removeAt(_currentConversationIndex);
        _conversations.insert(0, updated);
        _currentConversationIndex = 0;
      });
    });
  }

  void _deleteConversation(int index) {
    setState(() {
      _conversations.removeAt(index);
      if (_currentConversationIndex == index) {
        _currentConversationIndex = -1;
      } else if (_currentConversationIndex > index) {
        _currentConversationIndex--;
      }
    });
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? Colors.purpleAccent : Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: isUser ? const Radius.circular(14) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(14),
          ),
        ),
        child: Text(
          message["text"] ?? "",
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    final currentMessages = _currentConversationIndex == -1
        ? []
        : _conversations[_currentConversationIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI Assistant",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E0B5C),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ✅ New Chat button
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: "New Chat",
            onPressed: () {
              _startNewConversation();
            },
          ),
          // ✅ History button
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: _toggleSidebar,
          ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/static_loading_page.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main chat UI
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: currentMessages.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(currentMessages[index]);
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      12, 8, 12, paddingBottom > 0 ? paddingBottom : 8),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Ask me anything...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.purpleAccent),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sidebar overlay
          if (_isSidebarOpen)
            GestureDetector(
              onTap: _toggleSidebar,
              child: Container(color: Colors.black54),
            ),

          // Sidebar itself
          AnimatedBuilder(
            animation: _sidebarController,
            builder: (context, child) {
              final slide = MediaQuery.of(context).size.width * 0.7 *
                  _sidebarController.value;
              return Positioned(
                top: 0,
                bottom: 0,
                right: -MediaQuery.of(context).size.width * 0.7 + slide,
                child: child!,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              color: const Color(0xFF2E0B5C),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Text(
                        "Chat History",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _conversations[index];
                          final preview = conversation.isNotEmpty
                              ? conversation.firstWhere(
                                  (msg) => msg["role"] == "user",
                                  orElse: () => {"text": "New Conversation"},
                                )["text"]
                              : "New Conversation";

                          return ListTile(
                            leading: const Icon(Icons.chat,
                                color: Colors.white70),
                            title: Text(
                              preview ?? "New Conversation",
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _deleteConversation(index),
                            ),
                            onTap: () {
                              setState(() {
                                _currentConversationIndex = index;
                              });
                              _toggleSidebar();
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
