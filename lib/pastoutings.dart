import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back

class PastOutingsPage extends StatefulWidget {
  const PastOutingsPage({super.key});

  @override
  State<PastOutingsPage> createState() => _PastOutingsPageState();
}

class _PastOutingsPageState extends State<PastOutingsPage> {
  // Dummy data
  final List<Map<String, String>> _pastOutings = [
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

  // Store ratings & reviews
  final Map<int, int> _ratings = {}; // outing index → star rating
  final Map<int, String> _reviews = {}; // outing index → review text

  // Show dialog for review input
  void _showReviewDialog(int index) {
    int tempRating = _ratings[index] ?? 0;
    TextEditingController reviewController =
        TextEditingController(text: _reviews[index] ?? "");
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E0B5C),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Write a Review",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (starIndex) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: starIndex < tempRating
                            ? Colors.amber
                            : Colors.white24,
                      ),
                      onPressed: () {
                        setState(() {
                          tempRating = starIndex + 1;
                        });
                        Navigator.pop(context);
                        _showReviewDialog(index); // reopen to reflect star update
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                // Review text box
                TextFormField(
                  controller: reviewController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write your thoughts...",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Review cannot be empty";
                    }
                    if (val.trim().length < 10) {
                      return "Review must be at least 10 characters";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text("Save", style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _ratings[index] = tempRating;
                    _reviews[index] = reviewController.text.trim();
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Widget to show stars
  Widget _buildStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: index < rating ? Colors.amber : Colors.white24,
          size: 18,
        );
      }),
    );
  }

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
              // Header
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
                      "Past Outings",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // List of outings
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pastOutings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final outing = _pastOutings[index];
                    final rating = _ratings[index] ?? 0;
                    final review = _reviews[index] ?? "";

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
                          // Outing image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                const SizedBox(height: 10),
                                // Rating stars
                                _buildStars(rating),
                                const SizedBox(height: 6),
                                // Review text (if available)
                                if (review.isNotEmpty)
                                  Text(
                                    '"$review"',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic),
                                  ),
                                const SizedBox(height: 10),
                                // Review button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => _showReviewDialog(index),
                                    child: Text(
                                      review.isEmpty
                                          ? "Write Review"
                                          : "Edit Review",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
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
