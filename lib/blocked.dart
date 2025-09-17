import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back

class BlockedPeoplePage extends StatefulWidget {
  const BlockedPeoplePage({super.key});

  @override
  State<BlockedPeoplePage> createState() => _BlockedPeoplePageState();
}

class _BlockedPeoplePageState extends State<BlockedPeoplePage> {
  // Dummy blocked users data
  final List<Map<String, String>> _blockedUsers = [
    {
      "name": "Alice Johnson",
      "reason": "Spamming in chats",
      "image": "assets/images/profile_placeholder.png",
    },
    {
      "name": "Rahul Mehta",
      "reason": "Offensive messages",
      "image": "assets/images/profile_placeholder.png",
    },
    {
      "name": "Sophia Lee",
      "reason": "Fake account",
      "image": "assets/images/profile_placeholder.png",
    },
  ];

  final Color _primaryColor = const Color(0xFF2E0B5C);

  void _unblockUser(int index) {
    String userName = _blockedUsers[index]["name"]!;
    setState(() {
      _blockedUsers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$userName has been unblocked"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom heading like MyProfilePage
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Blocked People",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded ListView for blocked users
              Expanded(
                child: _blockedUsers.isEmpty
                    ? const Center(
                        child: Text(
                          "No blocked users",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _blockedUsers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final user = _blockedUsers[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundImage: AssetImage(user["image"]!),
                              ),
                              title: Text(
                                user["name"]!,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                user["reason"]!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 14),
                                ),
                                onPressed: () => _unblockUser(index),
                                child: const Text(
                                  "Unblock",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
