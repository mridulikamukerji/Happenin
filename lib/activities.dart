import 'package:flutter/material.dart';
import 'booking.dart'; // ✅ Import your booking page

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final List<Map<String, dynamic>> _activityItems = [
  {
    "image": "assets/images/activities/workshop1.png",
    "title": "Japanese Kintsugi Workshop",
    "description": "Step into the ancient Japanese philosophy of Kintsugi!",
    "date": "Oct 5, 2025",
    "time": "4:00 PM",
    "price": 1200.0,
    "venue": "Art Studio, Mumbai", // ✅ NEW
  },
  {
    "image": "assets/images/activities/workshop2.png",
    "title": "Designing Your Life with Navyug Mohnot",
    "description": "Build your way forward with an intentionally designed life!",
    "date": "Oct 6, 2025",
    "time": "6:00 PM",
    "price": 1500.0,
    "venue": "Community Hall, Delhi", // ✅ NEW
  },
  {
    "image": "assets/images/activities/workshop3.png",
    "title": "Belly Dance Workshop",
    "description": "Learn how to belly dance today!",
    "date": "Oct 4, 2025",
    "time": "3:00 PM",
    "price": 1000.0,
    "venue": "Dance Studio, Pune", // ✅ NEW
  },
  {
    "image": "assets/images/activities/workshop4.png",
    "title": "Pottery Wheel and Carving by Pastel Mystery",
    "description": "Join us for a hands-on pottery experience where creativity meets clay!",
    "date": "Oct 7, 2025",
    "time": "4:00 PM",
    "price": 1300.0,
    "venue": "Clay Art Cafe, Bangalore", // ✅ NEW
  },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
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
            itemCount: _activityItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _activityItems[index];
              return _ActivityCard(
                image: item["image"],
                title: item["title"],
                description: item["description"],
                date: item["date"],
                time: item["time"],
                price: item["price"], // ✅ Use price
                venue: item["venue"], // ✅ pass venue here
                onBook: () {
                  // ✅ Navigate to booking page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        title: item["title"],
                        image: item["image"],
                        description: item["description"],
                        date: item["date"],
                        time: item["time"],
                        venue: item["venue"],
                        price: item["price"], // ✅ Pass correct param
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

class _ActivityCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String date;
  final String time;
  final double price; 
  final String venue;
  final VoidCallback onBook;

  const _ActivityCard({
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
        color: const Color(0xFF2E0B5C).withOpacity(0.9), // background with opacity
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
                    const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${price.toStringAsFixed(2)} per person", // 💰 Display price
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
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
