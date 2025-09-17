import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back

class PastOutingsPage extends StatelessWidget {
  const PastOutingsPage({super.key});

  // Dummy data (reusing Spotlight from DashboardPage)
  final List<Map<String, String>> _pastOutings = const [
    {
      "image": "assets/images/spotlight1.png",
      "title": "Music Festival",
      "description": "You enjoyed live performances last weekend!",
      "date": "12 Sep 2025"
    },
    {
      "image": "assets/images/spotlight2.png",
      "title": "Art Exhibition",
      "description": "Explored modern art from top creators.",
      "date": "08 Sep 2025"
    },
    {
      "image": "assets/images/spotlight3.png",
      "title": "Food Carnival",
      "description": "Tasted cuisines from around the world.",
      "date": "01 Sep 2025"
    },
  ];

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
                      "Past Outings",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Expanded ListView for outings
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pastOutings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final outing = _pastOutings[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E0B5C).withOpacity(0.8),
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
                          // Outing image
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              outing["image"]!,
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
                                // Title + Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      outing["title"]!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      outing["date"]!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Description
                                Text(
                                  outing["description"]!,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
