import 'package:flutter/material.dart';
import 'diningbooking.dart'; // ✅ Import your booking page

class DiningPage extends StatefulWidget {
  const DiningPage({super.key});

  @override
  State<DiningPage> createState() => _DiningPageState();
}

class _DiningPageState extends State<DiningPage> {
  final List<Map<String, String>> _diningItems = [
    {
      "image": "assets/images/dining/dining1.png",
      "title": "British Brewing Company",
      "description": "Experience delicious cuisines and amazing service!",
      "venue": "123 London St, Mumbai",
    },
    {
      "image": "assets/images/dining/dining2.png",
      "title": "Nxt Lvl - Chembur",
      "description":
          "In a mood for North Indian? Japanese? Continental? This is the right place for you!",
      "venue": "45 Chembur Rd, Mumbai",
    },
    {
      "image": "assets/images/dining/dining3.png",
      "title": "Fresh Catch",
      "description": "Bringing Goa to your doorstep...",
      "venue": "78 Beach Ave, Goa",
    },
    {
      "image": "assets/images/dining/dining4.png",
      "title": "All Saints",
      "description": "Famous for leaving a lasting impression...",
      "venue": "22 High St, Pune",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dining"),
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
            itemCount: _diningItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _diningItems[index];
              return _DiningCard(
                image: item["image"]!,
                title: item["title"]!,
                description: item["description"]!,
                onBook: () {
                  // ✅ Navigate to dining booking page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiningBookingPage(
                        title: item["title"]!,
                        image: item["image"]!,
                        description: item["description"]!,
                        venue: item["venue"]!,
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

class _DiningCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onBook;

  const _DiningCard({
    required this.image,
    required this.title,
    required this.description,
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
