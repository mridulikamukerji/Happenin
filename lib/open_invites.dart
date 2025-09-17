import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ For navigation back
import 'chats.dart';
import 'shorts.dart';
import 'stories.dart';

class OpenInvitesPage extends StatefulWidget {
  const OpenInvitesPage({super.key});

  @override
  State<OpenInvitesPage> createState() => _OpenInvitesPageState();
}

class _OpenInvitesPageState extends State<OpenInvitesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color _slideColor = const Color(0xFF2E0B5C);

  final List<Map<String, dynamic>> _categories = [
    {
      "label": "For You",
      "events": [
        {
          "image": "assets/images/spotlight1.png",
          "title": "Music Festival",
          "description": "Experience live performances this weekend!",
          "date": "20 Sep 2025",
          "time": "7:00 PM"
        },
        {
          "image": "assets/images/spotlight2.png",
          "title": "Art Workshop",
          "description": "Unleash your creativity at our art workshop.",
          "date": "22 Sep 2025",
          "time": "3:00 PM"
        },
      ],
    },
    {
      "label": "Dining",
      "events": [
        {
          "image": "assets/images/spotlight3.png",
          "title": "Sushi Night",
          "description": "All you can eat sushi with live music.",
          "date": "23 Sep 2025",
          "time": "8:00 PM"
        },
      ],
    },
    {
      "label": "Movies",
      "events": [
        {
          "image": "assets/images/spotlight2.png",
          "title": "Movie Marathon",
          "description": "Watch back-to-back blockbusters with friends.",
          "date": "25 Sep 2025",
          "time": "6:00 PM"
        },
      ],
    },
    {
      "label": "Events",
      "events": [
        {
          "image": "assets/images/spotlight1.png",
          "title": "Stand-up Comedy",
          "description": "Laugh out loud with the best comedians.",
          "date": "28 Sep 2025",
          "time": "9:00 PM"
        },
      ],
    },
    {
      "label": "Activities",
      "events": [
        {
          "image": "assets/images/spotlight3.png",
          "title": "Mountain Trek",
          "description": "An unforgettable outdoor adventure trek.",
          "date": "1 Oct 2025",
          "time": "5:30 AM"
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Open Invites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _slideColor,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _categories
              .map((c) => Tab(text: c["label"].toString()))
              .toList(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final events = category["events"] as List<Map<String, String>>;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = events[index];
                return Container(
                  decoration: BoxDecoration(
                    color: _slideColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.asset(
                          event["image"]!,
                          fit: BoxFit.cover,
                          height: 160,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  event["title"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      event["date"]!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      event["time"]!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event["description"]!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.black.withOpacity(0.6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFooterItem(Icons.auto_stories, "Stories", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const StoriesPage()),
              );
            }),
            _buildFooterItem(Icons.chat_bubble, "Chats", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ChatsPage()),
              );
            }),
            _buildFooterItem(Icons.video_collection, "Shorts", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ShortsPage()),
              );
            }),
            _buildFooterItem(Icons.home, "Home", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
