import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  final Color _primaryColor = const Color(0xFF2E0B5C);

  final List<Map<String, String>> _founders = const [
    {
      "name": "Mridulika Mukerji",
      "role": "Founder and CEO",
      "bio":
          "Mridulika is passionate about connecting people through unique experiences. She drives the overall vision and strategy of HappenIn.",
      "image": "assets/images/founders/founder1.png",
    },
    {
      "name": "Atharva Naik",
      "role": "Founder and CEO",
      "bio":
          "Atharva is the brains behind the platform’s technology. He ensures HappenIn runs smoothly and scales to millions of users.",
      "image": "assets/images/founders/founder2.png",
    },
    {
      "name": "Nishika Shah",
      "role": "Founder and CEO",
      "bio":
          "Nishika focuses on building vibrant communities, ensuring safety, inclusivity, and unforgettable shared experiences.",
      "image": "assets/images/founders/founder3.png",
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
                      "About Us",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded ListView for content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App description
                      const Text(
                        "At HappenIn, we believe life is better when shared. "
                        "Our platform helps you discover events, meet people with similar interests, "
                        "and create lasting memories.",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "Meet the Founders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Founder cards
                      Column(
                        children: _founders.map((founder) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Founder picture
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      founder["image"]!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Founder details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          founder["name"]!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          founder["role"]!,
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          founder["bio"]!,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
