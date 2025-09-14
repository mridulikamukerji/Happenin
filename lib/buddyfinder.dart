import 'package:flutter/material.dart';

class BuddyFinderPage extends StatefulWidget {
  const BuddyFinderPage({super.key});

  @override
  State<BuddyFinderPage> createState() => _BuddyFinderPageState();
}

class _BuddyFinderPageState extends State<BuddyFinderPage> {
  final List<Map<String, dynamic>> _buddies = [
    {
      "image": "assets/images/buddy1.png",
      "name": "Eren Jaeger",
      "age": 19,
      "bio": "Passionate about freedom! Tatakae.",
      "interests": ["War", "Genocide", "Revenge"]
    },
    {
      "image": "assets/images/buddy2.png",
      "name": "Misa",
      "age": 26,
      "bio": "Done with red flags. In my self-love era!!",
      "interests": ["Art", "Cafes", "Travel"]
    },
    {
      "image": "assets/images/buddy3.png",
      "name": "Sukuna",
      "age": 1000,
      "bio": "Proudly a black flag. Periodt.",
      "interests": ["Mind Games", "Blackmail", "Cats"]
    },
    {
      "image": "assets/images/buddy4.png",
      "name": "Yor",
      "age": 28,
      "bio": "Mommy for hire here! Can't cook but I'm good with a knife.",
      "interests": ["Swords", "Assasin", "Goth"]
    },
  ];

  int _currentIndex = 0;

  void _onSwipe(bool isAccepted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isAccepted
              ? "You liked ${_buddies[_currentIndex]['name']}!"
              : "You skipped ${_buddies[_currentIndex]['name']}.",
        ),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (_currentIndex < _buddies.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Buddy Finder",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
              // This pushes everything below AppBar safely
              const SizedBox(height: 10),

              Expanded(
                child: Column(
                  children: [
                    // ✅ Instruction line right above slides
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Swipe left to skip   |   Swipe right to like",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _currentIndex < _buddies.length
                            ? Draggable(
                                onDragEnd: (details) {
                                  if (details.offset.dx > 100) {
                                    _onSwipe(true);
                                  } else if (details.offset.dx < -100) {
                                    _onSwipe(false);
                                  }
                                },
                                feedback: Material(
                                  type: MaterialType.transparency,
                                  child:
                                      _buildBuddyCard(_buddies[_currentIndex], size),
                                ),
                                childWhenDragging: Container(),
                                child:
                                    _buildBuddyCard(_buddies[_currentIndex], size),
                              )
                            : const Text(
                                "No more buddies!",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuddyCard(Map<String, dynamic> buddy, Size size) {
    return Center(
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2E0B5C),
              Color(0xFF5D2A84),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                buddy["image"],
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.black.withOpacity(0.35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${buddy['name']}, ${buddy['age']}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        buddy['bio'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (buddy['interests'] as List<String>).map((interest) {
                          return Chip(
                            label: Text(interest),
                            backgroundColor: const Color(0xFF5D2A84),
                            labelStyle: const TextStyle(color: Colors.white),
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
