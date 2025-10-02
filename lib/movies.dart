import 'package:flutter/material.dart';
import 'booking.dart'; // ✅ Import your booking page

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final List<Map<String, String>> _movieItems = [
    {
      "image": "assets/images/movies/movies1.png",
      "title": "Baahubali: The Epic",
      "description":
          "Baahubali: The Epic is a combined narrative of the two-part Indian film saga, weaving together the grandeur and drama of Baahubali: The Beginning and Baahubali: The Conclusion into one epic tale.",
      "date": "31 Oct, 2025",
      "time": "6:00 PM",
      "venue": "PVR Cinemas, Phoenix Mills, Lower Parel",
      "price": "500", // 💰 Added
    },
    {
      "image": "assets/images/movies/movies2.png",
      "title": "Ek Deewane Ki Deewaniyat",
      "description": "Love. Obsession. Heartbreak.",
      "date": "31 Oct, 2025",
      "time": "8:00 PM",
      "venue": "INOX, R City Mall, Ghatkopar",
      "price": "300", // 💰 Added
    },
    {
      "image": "assets/images/movies/movies3.png",
      "title": "Tron: Ares",
      "description":
          "Get ready for a thrilling ride where the virtal AI led world meets our own! When Ares, a powerful program, enters reality, the battle between man and AI begins.",
      "date": "10 Oct, 2025",
      "time": "7:00 PM",
      "venue": "Cinepolis, Kurla",
      "price": "450", // 💰 Added
    },
    {
      "image": "assets/images/movies/movies4.png",
      "title": "Thamma",
      "description":
          "Dinesh Vijan`s Maddock Horror comedy universe needed a love story. Unfortunately, it`s a bloody one.",
      "date": "21 Oct, 2025",
      "time": "4:00 PM",
      "venue": "PVR, Juhu",
      "price": "350", // 💰 Added
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
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
            itemCount: _movieItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _movieItems[index];
              return _MovieCard(
                image: item["image"]!,
                title: item["title"]!,
                description: item["description"]!,
                date: item["date"]!,
                time: item["time"]!,
                price: item["price"]!,
                venue: item["venue"]!,
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
                        price: double.tryParse(item["price"] ?? "0") ?? 0,
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

class _MovieCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String date;
  final String time;
  final String price;
  final String venue;
  final VoidCallback onBook;

  const _MovieCard({
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
                  "₹$price per ticket", // 💰 Show price
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
