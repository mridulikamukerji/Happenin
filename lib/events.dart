import 'package:flutter/material.dart';
import 'booking.dart'; // ✅ Import your booking page

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<Map<String, String>> _eventItems = [
    {
      "image": "assets/images/events/music1.png",
      "title": "The Sound of Tomorrow (TSOT)",
      "description":
          "Mumbai’s most anticipated underground music festival returns — and it’s bigger, bolder and louder than ever.",
      "date": "Oct 5, 2025",
      "time": "5:00 PM",
      "venue": "NSCI Dome, Worli",
      "price": "2000", // 💰 Added
    },
    {
      "image": "assets/images/events/music2.png",
      "title": "Epitome presents- Madhur Sharma Live",
      "description":
          "Get ready for a magical night filled with soulful music, celebratory vibes, and the signature Epitome experience. It’s more than a party – it’s a musical celebration of a milestone.",
      "date": "Oct 4, 2025",
      "time": "10:00 PM",
      "venue": "Blue Frog, Lower Parel",
      "price": "1500", // 💰 Added
    },
    {
      "image": "assets/images/events/music3.png",
      "title": "Papon | Shaam-E-Mehfil",
      "description":
          "Shaam-E-Mehfil is a performance presented by Papon with his band of super talented musicians of this country.",
      "date": "Oct 11, 2025",
      "time": "8:00 PM",
      "venue": "NCPA, Mumbai",
      "price": "1800", // 💰 Added
    },
    {
      "image": "assets/images/events/sports1.png",
      "title": "India VS New Zealand - ICC Women's CWC 2025",
      "description": "India takes on New Zealand in a critical match!!",
      "date": "Oct 23, 2025",
      "time": "3:00 PM",
      "venue": "Wankhede Stadium, Mumbai",
      "price": "1200", // 💰 Added
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: const Color(0xFF2E0B5C), // Dark purple theme
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: _eventItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _eventItems[index];
              return _EventCard(
                image: item["image"]!,
                title: item["title"]!,
                description: item["description"]!,
                date: item["date"]!,
                time: item["time"]!,
                venue: item["venue"]!,
                price: item["price"]!,
                onBook: () {
                  // ✅ Navigate to booking page with price
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        title: item["title"]!,
                        image: item["image"]!,
                        description: item["description"]!,
                        date: item["date"]!,
                        time: item["time"]!,
                        venue: item["venue"]!,
                        price: double.tryParse(item["price"] ?? "0") ?? 0,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String date;
  final String time;
  final String price;
  final String venue;
  final VoidCallback onBook;

  const _EventCard({
    required this.image,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.price,
    required this.venue,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E0B5C).withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              height: 160,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "₹$price per person", // 💰 Show price
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E0B5C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onBook,
                    child: const Text("Book"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
