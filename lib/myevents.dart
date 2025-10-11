import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ For navigation back to Dashboard
import 'booking.dart';  // ✅ To reuse your event booking view page

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  // Dummy data for booked events
  final List<Map<String, dynamic>> _myEvents = const [
    {
      "image": "assets/images/events/music1.png",
      "title": "The Sound of Tomorrow (TSOT)",
      "description":
          "Experience Mumbai’s biggest underground electronic festival — lights, beats, and pure energy.",
      "date": "Oct 5, 2025",
      "time": "5:00 PM",
      "venue": "NSCI Dome, Worli",
      "price": 2000.0,
    },
    {
      "image": "assets/images/events/music3.png",
      "title": "Papon | Shaam-E-Mehfil",
      "description":
          "A soulful evening of melody with Papon and his band, performing live at NCPA.",
      "date": "Oct 11, 2025",
      "time": "8:00 PM",
      "venue": "NCPA, Mumbai",
      "price": 1800.0,
    },
    {
      "image": "assets/images/activities/workshop4.png",
      "title": "Pottery Wheel & Carving Workshop",
      "description":
          "Unleash your creativity at a hands-on pottery workshop guided by expert artists.",
      "date": "Oct 7, 2025",
      "time": "4:00 PM",
      "venue": "Art Studio, Andheri",
      "price": 600.0,
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
              // 🔹 Header with back button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardPage()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "My Events",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 List of booked events
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _myEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final event = _myEvents[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E0B5C).withOpacity(0.85),
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
                          // 🔹 Event image
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

                          // 🔹 Event details
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and Date-Time
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event["title"]!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          event["date"]!,
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          event["time"]!,
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Description
                                Text(
                                  event["description"]!,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Venue: ${event["venue"]!}",
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(height: 10),

                                // 🔹 Buttons: View Details + Cancel
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.deepPurpleAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigate to booking view page (pre-confirmed)
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BookingPage(
                                              title: event["title"]!,
                                              image: event["image"]!,
                                              description:
                                                  event["description"]!,
                                              date: event["date"]!,
                                              time: event["time"]!,
                                              venue: event["venue"]!,
                                              price: event["price"],
                                              preConfirmed:
                                                  true, // ✅ already booked
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xFF2E0B5C),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              title: const Text(
                                                "Cancel Event",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                "Are you sure you want to cancel this event?",
                                                style: TextStyle(
                                                    color: Colors.white70),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Event cancelled successfully."),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Yes"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
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
