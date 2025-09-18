import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'chats.dart';
import 'shorts.dart';
import 'stories.dart';
import 'invitesbooking.dart'; // ✅ Import booking page

class OpenInvitesPage extends StatefulWidget {
  const OpenInvitesPage({super.key});

  @override
  State<OpenInvitesPage> createState() => _OpenInvitesPageState();
}

class _OpenInvitesPageState extends State<OpenInvitesPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _openSubTabController;

  final Color _slideColor = const Color(0xFF2E0B5C);

  String _genderFilter = "No Preferences"; // Default filter

  // ✅ Open Invites categories
  final List<Map<String, dynamic>> _categories = [
    {
      "label": "For You",
      "events": [
        {
          "image": "assets/images/spotlight1.png",
          "title": "Music Festival",
          "description": "Experience live performances this weekend!",
          "date": "20 Sep 2025",
          "time": "7:00 PM",
          "rating": 4,
          "gender": "Man",
        },
        {
          "image": "assets/images/spotlight2.png",
          "title": "Art Workshop",
          "description": "Unleash your creativity at our art workshop.",
          "date": "22 Sep 2025",
          "time": "3:00 PM",
          "rating": 5,
          "gender": "Woman",
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
          "time": "8:00 PM",
          "rating": 3,
          "gender": "No Preference",
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
          "time": "6:00 PM",
          "rating": 4,
          "gender": "Man",
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
          "time": "9:00 PM",
          "rating": 5,
          "gender": "Woman",
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
          "time": "5:30 AM",
          "rating": 4,
          "gender": "No Preference",
        },
      ],
    },
  ];

  // ✅ Private Invites
  final List<Map<String, dynamic>> _privateInvites = [
    {
      "image": "assets/images/spotlight1.png",
      "title": "Private Dinner",
      "description": "An exclusive dining experience with a 5-course meal.",
      "date": "21 Sep 2025",
      "time": "8:00 PM",
      "rating": 5,
    },
    {
      "image": "assets/images/spotlight2.png",
      "title": "VIP Movie Night",
      "description": "Private screening of the latest blockbuster.",
      "date": "24 Sep 2025",
      "time": "7:30 PM",
      "rating": 4,
    },
    {
      "image": "assets/images/spotlight3.png",
      "title": "Private Yacht Party",
      "description": "Luxury yacht evening with live DJ and cocktails.",
      "date": "30 Sep 2025",
      "time": "6:00 PM",
      "rating": 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _openSubTabController =
        TabController(length: _categories.length, vsync: this);
  }

  List<Map<String, dynamic>> _applyGenderFilter(List<Map<String, dynamic>> events) {
    if (_genderFilter == "Men Only") {
      return events.where((e) => e["gender"] == "Man").toList();
    } else if (_genderFilter == "Women Only") {
      return events.where((e) => e["gender"] == "Woman").toList();
    }
    return events; // No Preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Invites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _slideColor,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(95),
          child: Column(
            children: [
              // ✅ Gender Filter Toggle moved here
              Container(
                color: _slideColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleButtons(
                  isSelected: [
                    _genderFilter == "Men Only",
                    _genderFilter == "Women Only",
                    _genderFilter == "No Preferences",
                  ],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) {
                        _genderFilter = "Men Only";
                      } else if (index == 1) {
                        _genderFilter = "Women Only";
                      } else {
                        _genderFilter = "No Preferences";
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  fillColor: const Color(0xFF5D2A84),
                  selectedColor: Colors.white,
                  color: Colors.white70,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Men Only"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Women Only"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("No Preferences"),
                    ),
                  ],
                ),
              ),
              // ✅ Tabs below the gender toggle
              TabBar(
                controller: _mainTabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: "Open Invites"),
                  Tab(text: "Private Invites"),
                ],
              ),
            ],
          ),
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
          controller: _mainTabController,
          children: [
            // ✅ Open Invites with sub-tabs
            Column(
              children: [
                // ⭐ Sub-tabs for categories
                Material(
                  color: _slideColor,
                  child: TabBar(
                    controller: _openSubTabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: _categories
                        .map((c) => Tab(text: c["label"].toString()))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _openSubTabController,
                    children: _categories.map((category) {
                      final events =
                          _applyGenderFilter(category["events"] as List<Map<String, dynamic>>);
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _buildEventCard(context, event);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // ✅ Private Invites list
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _privateInvites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = _privateInvites[index];
                return _buildEventCard(context, event);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  // ✅ Reusable Event Card
  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    final int rating = event["rating"] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: _slideColor.withOpacity(0.85),
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
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              event["image"],
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
                // Title + Date/Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event["title"],
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
                          event["date"],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          event["time"],
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
                // Description
                Text(
                  event["description"],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                // ⭐ Display Rating
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 22,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                // 🟣 Join button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvitesBookingPage(
                            title: event["title"],
                            image: event["image"],
                            description: event["description"],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Join",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Footer
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
