import 'package:flutter/material.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add({"role": "user", "text": userMessage});
    });

    _controller.clear();

    // Mock AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          "role": "ai",
          "text": "You said: \"$userMessage\". I'm here to assist you!"
        });
      });
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "AI Assistant",
          style: TextStyle(color: Colors.white), // ✅ White text
        ),
        backgroundColor: const Color(0xFF2E0B5C), // ✅ Dark purple
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ White back button
      ),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input field
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  12, 8, 12, paddingBottom > 0 ? paddingBottom : 8),
              color: Colors.grey[900],
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
    );
  }
}
