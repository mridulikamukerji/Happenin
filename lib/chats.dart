import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'dashboard.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final Color _slideColor = const Color(0xFF2E0B5C);
  int _currentFooterIndex = 1;

  List<Map<String, dynamic>> chats = [];
  Set<int> selectedChats = {}; // For multi-selection

  final List<Map<String, dynamic>> people = [
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
    }
  ];

  Set<int> selectedPeople = {};

  void _openNewChatModal() {
    selectedPeople = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _slideColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        String searchQuery = "";

        return StatefulBuilder(
          builder: (context, setModalState) {
            List<int> selectedIndices = selectedPeople.toList();
            List<int> unselectedIndices =
                List.generate(people.length, (i) => i)
                  ..removeWhere((i) => selectedPeople.contains(i));
            List<int> orderedIndices = [...selectedIndices, ...unselectedIndices];

            List<int> filteredIndices = orderedIndices.where((i) {
              String name = people[i]['name'].toString().toLowerCase();
              return name.contains(searchQuery.toLowerCase());
            }).toList();

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setModalState(() => searchQuery = value);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search people...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // People List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredIndices.length,
                        itemBuilder: (context, idx) {
                          int personIndex = filteredIndices[idx];
                          var person = people[personIndex];
                          bool isSelected =
                              selectedPeople.contains(personIndex);

                          return Card(
                            color: Colors.black.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selectedPeople.remove(personIndex);
                                  } else {
                                    selectedPeople.add(personIndex);
                                  }
                                });
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(person['image']),
                                  radius: 25,
                                ),
                                title: Text(
                                  "${person['name']}, ${person['age']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  person['bio'],
                                  style:
                                      const TextStyle(color: Colors.white70),
                                ),
                                trailing: Checkbox(
                                  value: isSelected,
                                  activeColor: Colors.purpleAccent,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    setModalState(() {
                                      if (value == true) {
                                        selectedPeople.add(personIndex);
                                      } else {
                                        selectedPeople.remove(personIndex);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.chat, color: Colors.white),
                            label: const Text(
                              "Start Chat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: selectedPeople.isEmpty
                                ? null
                                : () {
                                    List<Map<String, dynamic>> participants =
                                        selectedPeople
                                            .map((i) => people[i])
                                            .toList();

                                    Map<String, dynamic> newChat = {
                                      "name": participants.length == 1
                                          ? participants[0]['name']
                                          : participants
                                              .map((p) => p['name'])
                                              .join(", "),
                                      "image": participants.length == 1
                                          ? participants[0]['image']
                                          : "assets/images/groupchat.png",
                                      "lastMessage": "Say hi 👋",
                                      "messages": [
                                        {
                                          "sender": "System",
                                          "text": "Chat started"
                                        }
                                      ],
                                      "participants": participants,
                                    };

                                    setState(() {
                                      chats.add(newChat);
                                    });

                                    Navigator.pop(context);

                                    // Navigate to ChatScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatName: newChat['name'],
                                          messages: newChat['messages'],
                                          participants: newChat['participants'],
                                        ),
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFooterItem(IconData icon, String label, int index,
      {VoidCallback? onTap}) {
    final bool isActive = _currentFooterIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.purpleAccent : Colors.white70,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.purpleAccent : Colors.white70,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSelectedChats() async {
    if (selectedChats.isEmpty) return;

    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          "Delete Chats",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete ${selectedChats.length} chat(s)?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm) {
      setState(() {
        chats = List.from(chats)
          ..removeWhere((chat) => selectedChats.contains(chats.indexOf(chat)));
        selectedChats.clear();
      });
    }
  }

  void _showProfilePicture(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Image.asset(imagePath),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSelectionMode = selectedChats.isNotEmpty;

    return Scaffold(
      backgroundColor: _slideColor,
      appBar: AppBar(
  backgroundColor: _slideColor,
  leading: isSelectionMode
      ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              selectedChats.clear();
            });
          },
        )
      : null,
  title: Text(
    isSelectionMode
        ? '${selectedChats.length} selected'
        : 'Chats',
    style: const TextStyle(color: Colors.white), // always white
  ),
  actions: isSelectionMode
      ? [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white), // white delete
            onPressed: _deleteSelectedChats,
          )
        ]
      : null,
  centerTitle: true,
),


      body: Column(
        children: [
          // Search bar for chats
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search chats...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: chats.isEmpty
                ? const Center(
                    child: Text(
                      'No chats yet. Start chatting now!',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedChats.contains(index);
                      var chat = chats[index];

                      return Card(
                        color: isSelected
                            ? Colors.purpleAccent.withOpacity(0.6)
                            : Colors.black.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (isSelectionMode) {
                              setState(() {
                                if (isSelected) {
                                  selectedChats.remove(index);
                                } else {
                                  selectedChats.add(index);
                                }
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    chatName: chat['name'],
                                    messages: chat['messages'],
                                    participants: chat['participants'],
                                  ),
                                ),
                              );
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              selectedChats.add(index);
                            });
                          },
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => _showProfilePicture(chat['image']),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(chat['image']),
                                radius: 25,
                              ),
                            ),
                            title: Text(
                              chat['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              chat['lastMessage'],
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: isSelectionMode
                                ? Checkbox(
                                    value: isSelected,
                                    activeColor: Colors.purpleAccent,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedChats.add(index);
                                        } else {
                                          selectedChats.remove(index);
                                        }
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewChatModal,
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color: Colors.black.withOpacity(0.6),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFooterItem(Icons.auto_stories, "Stories", 0, onTap: () {
                setState(() => _currentFooterIndex = 0);
              }),
              _buildFooterItem(Icons.chat_bubble, "Chats", 1, onTap: () {
                setState(() => _currentFooterIndex = 1);
              }),
              _buildFooterItem(Icons.video_collection, "Shorts", 2, onTap: () {
                setState(() => _currentFooterIndex = 2);
              }),
              _buildFooterItem(Icons.home, "Home", 3, onTap: () {
                setState(() => _currentFooterIndex = 3);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
