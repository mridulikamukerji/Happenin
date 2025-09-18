import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:happenin/aboutus.dart';
import 'package:happenin/blocked.dart';
import 'package:happenin/contactus.dart';
import 'package:happenin/faq.dart';
import 'package:happenin/main.dart';
import 'package:happenin/pastoutings.dart';
import 'buddyfinder.dart';
import 'chats.dart';
import 'shorts.dart';
import 'stories.dart';
import 'aisassistant.dart';
import 'foryou.dart';
import 'dining.dart';
import 'movies.dart';
import 'events.dart';
import 'activities.dart';
import 'booking.dart';
import 'myprofile.dart';
import 'upcoming_outings.dart';
import 'open_invites.dart'; // ✅ added
import 'maps.dart';        // ✅ added

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  int _currentFooterIndex = 3;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color _slideColor = const Color(0xFF2E0B5C);

  final List<String> _headings = [
    "Invites",
    "Find your Buddies",
    "Map of Events",
  ];

  final List<String> _carouselImages = [
    "assets/images/openInvitesSlide.png",
    "assets/images/buddyFinderSlide.png",
    "assets/images/mapSlide.png",
  ];

  final List<Map<String, String>> _spotlightItems = [
    {
      "image": "assets/images/spotlight1.png",
      "title": "Music Festival",
      "description": "Experience live performances this weekend!",
    },
    {
      "image": "assets/images/spotlight2.png",
      "title": "Art Exhibition",
      "description": "Explore modern art from top creators.",
    },
    {
      "image": "assets/images/spotlight3.png",
      "title": "Food Carnival",
      "description": "Taste cuisines from around the world.",
    },
  ];

  final List<String> _locations = [
    "Mumbai, Maharashtra - 400001",
    "Delhi, Connaught Place - 110001",
    "Bangalore, MG Road - 560001",
    "Chennai, T Nagar - 600017",
    "Hyderabad, Banjara Hills - 500034",
    "Pune, FC Road - 411005",
    "Kolkata, Park Street - 700016",
    "Jaipur, MI Road - 302001",
  ];

  String _selectedLocation = "Mumbai, Maharashtra - 400001";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: null,

      // ✅ Sidebar Drawer
      endDrawer: Drawer(
        backgroundColor: _slideColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _slideColor),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage("assets/images/profile_placeholder.png"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "User Name",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.person, "My Profile", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyProfilePage()),
              );
            }),
            _buildDrawerItem(Icons.person, "Upcoming Outings", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UpcomingOutingsPage()),
              );
            }),
            _buildDrawerItem(Icons.history, "Past Outings", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PastOutingsPage()),
              );
            }),
            _buildDrawerItem(Icons.block, "Blocked People", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BlockedPeoplePage()),
              );
            }),
            _buildDrawerItem(Icons.help, "FAQs", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FAQsPage()),
              );
            }),
            _buildDrawerItem(Icons.info, "About Us", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
            }),
            _buildDrawerItem(Icons.contact_mail, "Contact Us", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsPage()),
              );
            }),
            _buildDrawerItem(Icons.logout, "Log Out", onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
  top: false,
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      border: const Border(
        top: BorderSide(color: Colors.white24, width: 0.5),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFooterItem(Icons.auto_stories, "Stories", 0, onTap: () {
          setState(() => _currentFooterIndex = 0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StoriesPage()),
          );
        }),
        _buildFooterItem(Icons.chat_bubble, "Chats", 1, onTap: () {
          setState(() => _currentFooterIndex = 1);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ChatsPage()),
          );
        }),
        _buildFooterItem(Icons.video_collection, "Shorts", 2, onTap: () {
          setState(() => _currentFooterIndex = 2);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ShortsPage()),
          );
        }),
        _buildFooterItem(Icons.home, "Home", 3, onTap: () {
          setState(() => _currentFooterIndex = 3);
        }),
      ],
    ),
  ),
),


      body: Builder(
        builder: (context) => Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/static_loading_page.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showLocationDropdown(context);
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                      "assets/images/location_pin.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedLocation,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  "assets/images/profile_placeholder.png"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildMainContent(context),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Button (AI)
            Positioned(
              bottom: math.max(MediaQuery.of(context).padding.bottom, 20),
              right: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiAssistantPage()),
                  );
                },
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/ai_assistant_logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item builder
  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }

  // Main content
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search bar
        TextField(
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
        const SizedBox(height: 12),

        // Fixed Options
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OptionItem(
              imagePath: "assets/images/for_you.png",
              label: "For You",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForYouPage()),
                );
              },
            ),
            OptionItem(
              imagePath: "assets/images/dining.png",
              label: "Dining",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DiningPage()),
                );
              },
            ),
            OptionItem(
              imagePath: "assets/images/movies.png",
              label: "Movies",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoviesPage()),
                );
              },
            ),
            OptionItem(
              imagePath: "assets/images/events.png",
              label: "Events",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EventsPage()),
                );
              },
            ),
            OptionItem(
              imagePath: "assets/images/activities.png",
              label: "Activities",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivitiesPage()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Carousel Heading
        Center(
          child: Text(
            _headings[_currentIndex],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.85,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _carouselImages.asMap().entries.map((entry) {
            final imagePath = entry.value;
            final index = entry.key;

            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OpenInvitesPage()),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BuddyFinderPage()),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapsPage()),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: _slideColor,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselImages.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Spotlight
        const Center(
          child: Text(
            "In the Spotlight",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _spotlightItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _spotlightItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        title: item["title"]!,
                        image: item["image"]!,
                        description: item["description"]!,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: _slideColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          item["image"]!,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["description"] ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  void _showLocationDropdown(BuildContext context) {
    final List<String> reorderedLocations = [
      _selectedLocation,
      ..._locations.where((loc) => loc != _selectedLocation),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: reorderedLocations.length,
          itemBuilder: (context, index) {
            final location = reorderedLocations[index];
            final isSelected = location == _selectedLocation;
            return ListTile(
              title: Text(
                location,
                style: TextStyle(
                  color: isSelected ? Colors.purpleAccent : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              tileColor: isSelected ? Colors.white12 : Colors.transparent,
              onTap: () {
                setState(() {
                  _selectedLocation = location;
                });
                Navigator.pop(context);
              },
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
            color: isActive ? Colors.purpleAccent : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.purpleAccent : Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionItem extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback? onTap;

  const OptionItem({
    super.key,
    required this.imagePath,
    required this.label,
    this.onTap,
  });

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF2E0B5C) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(widget.imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
