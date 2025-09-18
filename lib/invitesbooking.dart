import 'package:flutter/material.dart';
import 'payment.dart'; // ✅ Import payment page here

class InvitesBookingPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;

  const InvitesBookingPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  State<InvitesBookingPage> createState() => _InvitesBookingPageState();
}

class _InvitesBookingPageState extends State<InvitesBookingPage> {
  DateTime? _selectedDateTime;
  bool _bookingConfirmed = false;

  final String _venueAddress = "123 Dummy Venue Street, Wonderland City";

  final DateTime _scheduledEventDateTime = DateTime(2025, 12, 25, 18, 0);

  final int _eventRating = 4; // Example event rating (0–5)

  final List<Map<String, dynamic>> _attendingParticipants = [
    {
      "image": "assets/images/buddy1.png",
      "name": "Eren Jaeger",
      "age": 19,
      "bio": "Passionate about freedom! Tatakae.",
      "interests": ["War", "Genocide", "Revenge"],
      "gender": "Man",
    },
    {
      "image": "assets/images/buddy2.png",
      "name": "Misa",
      "age": 26,
      "bio": "Done with red flags. In my self-love era!!",
      "interests": ["Art", "Cafes", "Travel"],
      "gender": "Woman",
    },
    {
      "image": "assets/images/buddy3.png",
      "name": "Sukuna",
      "age": 1000,
      "bio": "Proudly a black flag. Periodt.",
      "interests": ["Mind Games", "Blackmail", "Cats"],
      "gender": "Man",
    },
    {
      "image": "assets/images/buddy4.png",
      "name": "Yor",
      "age": 28,
      "bio": "Mommy for hire here! Can't cook but I'm good with a knife.",
      "interests": ["Swords", "Assassin", "Goth"],
      "gender": "Woman",
    },
  ];

  final List<Map<String, String>> _feedbackList = [
    {
      "user": "Eren Jaeger",
      "comment": "Great event last time! Can't wait to join again."
    },
    {
      "user": "Misa",
      "comment": "Loved the vibe. Hoping for more art-related talks!"
    },
    {
      "user": "Sukuna",
      "comment": "Chaos was fun, more challenges next time 😈"
    },
    {
      "user": "Yor",
      "comment": "Met wonderful people here. Highly recommended!"
    },
  ];

  int get _peopleCount => _attendingParticipants.length;

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2E0B5C),
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            timePickerTheme: const TimePickerThemeData(
              dialHandColor: Color(0xFF2E0B5C),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final chosenDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (chosenDateTime.isBefore(_scheduledEventDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("You cannot book before the scheduled event date/time.")),
      );
      return;
    }

    setState(() {
      _selectedDateTime = chosenDateTime;
    });
  }

  void _goToPayment() async {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date & time before payment.")),
      );
      return;
    }

    final paymentSuccess = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentPage()),
    );

    if (paymentSuccess == true) {
      final dateStr =
          "${_selectedDateTime!.year}-${_selectedDateTime!.month.toString().padLeft(2, '0')}-${_selectedDateTime!.day.toString().padLeft(2, '0')}";
      final timeStr =
          "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}";

      setState(() {
        _bookingConfirmed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Payment Successful! Booking confirmed on $dateStr at $timeStr!",
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment failed or cancelled. Booking not confirmed."),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDate =
        "${_scheduledEventDateTime.day} ${_monthName(_scheduledEventDateTime.month)} ${_scheduledEventDateTime.year}";
    final scheduledTime =
        "${_scheduledEventDateTime.hour > 12 ? _scheduledEventDateTime.hour - 12 : _scheduledEventDateTime.hour}:${_scheduledEventDateTime.minute.toString().padLeft(2, '0')} ${_scheduledEventDateTime.hour >= 12 ? "PM" : "AM"}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Invites: ${widget.title}"),
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
        child: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
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
                const SizedBox(height: 15),

                // ⭐ Event Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return Icon(
                      i < _eventRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 26,
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // ✅ Event Date & Time Info
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Scheduled Event Date:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scheduledDate,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Scheduled Event Time:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scheduledTime,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Venue:",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _venueAddress,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ✅ Collapsible Attending Participants
                ExpansionTile(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  collapsedBackgroundColor: Colors.white.withOpacity(0.1),
                  title: Text(
                    "Attending Participants ($_peopleCount)",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  children: _attendingParticipants.map((p) {
                    return Card(
                      color: const Color(0xFF2E0B5C).withOpacity(0.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(p["image"]),
                          radius: 28,
                        ),
                        title: Text(
                          "${p["name"]} (${p["gender"]})",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Age: ${p["age"]}\nBio: ${p["bio"]}\nInterests: ${p["interests"].join(", ")}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 💬 Collapsible Feedback Section
                ExpansionTile(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  collapsedBackgroundColor: Colors.white.withOpacity(0.1),
                  title: const Text(
                    "Feedback from Past Attendees",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  children: _feedbackList.map((f) {
                    return ListTile(
                      leading: const Icon(Icons.comment, color: Colors.white),
                      title: Text(
                        f["user"]!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        f["comment"]!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // ✅ Select Date & Pay
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E0B5C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDateTime == null
                        ? "Select Booking Date & Time"
                        : "Date: ${_selectedDateTime!.year}-${_selectedDateTime!.month.toString().padLeft(2, '0')}-${_selectedDateTime!.day.toString().padLeft(2, '0')} "
                            "at ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _pickDateTime,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2E0B5C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month];
  }
}
