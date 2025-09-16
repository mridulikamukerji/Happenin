import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String chatName;
  final List<Map<String, dynamic>> messages;
  final List<Map<String, dynamic>> participants;

  const ChatScreen({
    super.key,
    required this.chatName,
    required this.messages,
    required this.participants,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Color _bgColor = const Color(0xFF2E0B5C);
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  late List<Map<String, dynamic>> _messages;
  late List<Map<String, dynamic>> _participants;
  String? _groupImage;
  bool _hasLeftChat = false;
  bool _isGroupNameManuallyEdited = false;
  Set<String> _blockedParticipants = {};

  final List<Map<String, dynamic>> _allBuddies = [
    {
      "image": "assets/images/buddy1.png",
      "name": "Eren Jaeger",
      "age": 19,
      "bio": "Passionate about freedom! Tatakae.",
    },
    {
      "image": "assets/images/buddy2.png",
      "name": "Misa",
      "age": 26,
      "bio": "Done with red flags. In my self-love era!!",
    },
    {
      "image": "assets/images/buddy3.png",
      "name": "Sukuna",
      "age": 1000,
      "bio": "Proudly a black flag. Periodt.",
    },
    {
      "image": "assets/images/buddy4.png",
      "name": "Yor",
      "age": 28,
      "bio": "Mommy for hire here! Can't cook but I'm good with a knife.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages);
    _participants = List.from(widget.participants);
    _groupNameController.text = widget.chatName;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _groupNameController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty || _hasLeftChat) return;

    setState(() {
      _messages.add({
        "sender": "You",
        "text": _messageController.text.trim(),
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickGroupImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _groupImage = pickedFile.path;
        _messages.add({
          "sender": "System",
          "text": "Group photo was changed",
        });
      });
    }
  }

  void _updateGroupName(String name, {bool manualEdit = true}) {
    if (name.trim().isEmpty) return;
    setState(() {
      _groupNameController.text = name;
      if (manualEdit) _isGroupNameManuallyEdited = true;

      _messages.add({
        "sender": "System",
        "text": "Group name was changed to \"$name\"",
      });
    });
  }

  void _addParticipant(Map<String, dynamic> buddy) {
    setState(() {
      _participants.add({"name": buddy['name'], "image": buddy['image']});
      _messages.add({
        "sender": "System",
        "text": "${buddy['name']} was added to the group",
      });

      // Update group name automatically only if not manually edited
      if (!_isGroupNameManuallyEdited) {
        String names = _participants.map((p) => p['name']).join(", ");
        _updateGroupName(names, manualEdit: false);
      }
    });
  }

  void _blockParticipant(String name) {
    setState(() {
      _blockedParticipants.add(name);
      _messages.add({
        "sender": "System",
        "text": "$name has been blocked",
      });
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    if (message['sender'] == "System") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message['text'] ?? "",
              style: const TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    bool isMe = message['sender'] == "You";

    if (_blockedParticipants.contains(message['sender'])) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.purpleAccent : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft:
                isMe ? const Radius.circular(14) : const Radius.circular(0),
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(14),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                message['sender'] ?? "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              message['text'] ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    if (_hasLeftChat) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text(
          "You have left the chat.",
          style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.purpleAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _openGroupSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickGroupImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: _groupImage != null
                                    ? FileImage(File(_groupImage!))
                                    : const AssetImage(
                                        "assets/images/groupchat.png"),
                              ),
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.purpleAccent,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _groupNameController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purpleAccent)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purpleAccent)),
                            hintText: "Enter group name",
                            hintStyle: const TextStyle(color: Colors.white54),
                          ),
                          onChanged: (val) {
                            if (!_isGroupNameManuallyEdited) {
                              _isGroupNameManuallyEdited = true;
                            }
                          },
                          onSubmitted: (val) => _updateGroupName(val),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Edit group name above",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Participants",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._participants.map((p) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(p['image']),
                      ),
                      title: Text(
                        p['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Block"),
                        onPressed: () => _blockParticipant(p['name']),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle,
                          color: Colors.purpleAccent, size: 36),
                      onPressed: _showAddParticipantDialog,
                    ),
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.red),
                    title: const Text("Leave Chat",
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      setState(() {
                        _hasLeftChat = true;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You left the chat")),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddParticipantDialog() {
    List<Map<String, dynamic>> availableBuddies = _allBuddies
        .where((b) => !_participants.any((p) => p['name'] == b['name']))
        .toList();

    List<Map<String, dynamic>> selected = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            List<Map<String, dynamic>> sorted = [
              ...selected,
              ...availableBuddies.where((b) => !selected.contains(b))
            ];

            return AlertDialog(
              backgroundColor: Colors.black87,
              title: const Text(
                "Add Participants",
                style: TextStyle(color: Colors.white),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    var buddy = sorted[index];
                    bool isSelected = selected.contains(buddy);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(buddy['image']),
                      ),
                      title: Text(
                        buddy['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selected.add(buddy);
                            } else {
                              selected.remove(buddy);
                            }
                          });
                        },
                      ),
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            selected.remove(buddy);
                          } else {
                            selected.add(buddy);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white70)),
                ),
                TextButton(
                  onPressed: () {
                    for (var buddy in selected) {
                      _addParticipant(buddy);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add",
                      style: TextStyle(color: Colors.purpleAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: _pickGroupImage,
              child: CircleAvatar(
                backgroundImage: _groupImage != null
                    ? FileImage(File(_groupImage!))
                    : (_participants.length == 1
                        ? AssetImage(_participants[0]['image'])
                        : const AssetImage("assets/images/groupchat.png"))
                        as ImageProvider,
                radius: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _groupNameController.text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _openGroupSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: _buildInputBar(),
          ),
        ],
      ),
    );
  }
}
