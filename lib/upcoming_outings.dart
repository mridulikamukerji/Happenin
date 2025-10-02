import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back
import 'booking.dart';  // ✅ Import booking page

class UpcomingOutingsPage extends StatelessWidget {
  const UpcomingOutingsPage({super.key});

  // Dummy data for upcoming outings
  final List<Map<String, dynamic>> _upcomingOutings = const [
    {
      "image": "assets/images/spotlight1.png",
      "title": "Beach Party",
      "description": "Get ready for a fun-filled evening at the beach!",
      "date": "25 Sep 2025",
      "time": "5:00 PM",
      "venue": "Juhu Beach, Mumbai",
      "price": 499.0, // ✅ Added price
    },
    {
      "image": "assets/images/spotlight2.png",
      "title": "Stand-up Comedy Night",
      "description": "Laugh out loud with the best comedians in town.",
      "date": "30 Sep 2025",
      "time": "8:30 PM",
      "venue": "Blue Frog, Lower Parel",
      "price": 299.0, // ✅ Added price
    },
    {
      "image": "assets/images/spotlight3.png",
      "title": "Adventure Trek",
      "description": "Join us for an unforgettable mountain trek adventure.",
      "date": "05 Oct 2025",
      "time": "6:00 AM",
      "venue": "Sahyadri Hills, Lonavala",
      "price": 799.0, // ✅ Added price
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
                      "Upcoming Outings",
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
                  itemCount: _upcomingOutings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final outing = _upcomingOutings[index];
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
                                // Title + Date + Time
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          outing["date"]!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          outing["time"]!,
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
                                  outing["description"]!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // View Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      // ✅ Navigate to booking page with pre-confirmed outing
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingPage(
                                            title: outing["title"]!,
                                            image: outing["image"]!,
                                            description: outing["description"]!,
                                            date: outing["date"]!,
                                            time: outing["time"]!,
                                            price: outing["price"], // ✅ Pass price
                                            venue: outing["venue"]!,
                                            preConfirmed: true, // ✅ indicates already booked
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("View",
                                        style: TextStyle(color: Colors.white)),
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
