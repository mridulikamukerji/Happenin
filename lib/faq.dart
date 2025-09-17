import 'package:flutter/material.dart';
import 'dashboard.dart'; // ✅ To navigate back

class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});

  final Color _primaryColor = const Color(0xFF2E0B5C);

  final List<Map<String, String>> _faqs = const [
    {
      "question": "How do I create an account?",
      "answer":
          "Tap on the Sign Up button on the login screen, enter your details, and verify your email to create an account."
    },
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to the login screen, tap on 'Forgot Password?', and follow the instructions to reset your password."
    },
    {
      "question": "How do I book an event?",
      "answer":
          "Go to the Events section, select the event you want, and tap on 'Book Now'. You can pay securely via multiple options."
    },
    {
      "question": "How do I block or unblock someone?",
      "answer":
          "Open their profile, tap on the three-dot menu, and select 'Block'. To unblock, go to Blocked People in the sidebar."
    },
    {
      "question": "How do I contact support?",
      "answer":
          "Go to My Profile > Settings > Contact Support. You can chat with our team or raise a support ticket."
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
                      "FAQs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded ListView for FAQs
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _faqs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final faq = _faqs[index];
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent, // remove expansion divider
                      ),
                      child: Container(
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
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white70,
                          iconColor: Colors.purpleAccent,
                          title: Text(
                            faq["question"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                faq["answer"]!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
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
