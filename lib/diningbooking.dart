import 'package:flutter/material.dart';
import 'payment.dart';

class DiningBookingPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String venue;

  const DiningBookingPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.venue,
  });

  @override
  State<DiningBookingPage> createState() => _DiningBookingPageState();
}

class _DiningBookingPageState extends State<DiningBookingPage> {
  bool _bookingConfirmed = false;
  final double _bookingFee = 80; // Hardcoded price per person

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentPage()),
    ).then((success) {
      if (success == true) {
        setState(() {
          _bookingConfirmed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Booking confirmed for ${widget.title}!",
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Cancel Booking",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to cancel? A cancellation fee of Rs. 80 will be charged.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Changed my mind"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentPage()),
              ).then((success) {
                if (success == true) {
                  setState(() {
                    _bookingConfirmed = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Booking cancelled. Rs. 80 cancellation fee successfully paid."),
                    ),
                  );
                }
              });
            },
            child: const Text("Pay Cancellation Fee"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.title}"),
        backgroundColor: const Color(0xFF2E0B5C),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Venue: ${widget.venue}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Booking Fee: ₹$_bookingFee per person",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E0B5C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _goToPayment,
                  ),
                  const SizedBox(height: 20),
                  if (_bookingConfirmed)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.cancel),
                      label: const Text(
                        "Cancel Booking",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: _cancelBooking,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
