import 'package:flutter/material.dart';
import 'payment.dart'; 

class BookingPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;

  const BookingPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDateTime;
  bool _bookingConfirmed = false; // ✅ Track booking status

  final DateTime _scheduledEventDateTime =
      DateTime(2025, 12, 25, 18, 0);

  final List<Map<String, dynamic>> _allParticipants = [
    {
      "image": "assets/images/buddy1.png",
      "name": "Eren Jaeger",
      "age": 19,
      "bio": "Passionate about freedom! Tatakae.",
    },
    {
      "image": "assets/images/buddy2.png",
      "name": "Misa",
      "age": 26,
      "bio": "Done with red flags. In my self-love era!!",
    },
    {
      "image": "assets/images/buddy3.png",
      "name": "Sukuna",
      "age": 1000,
      "bio": "Proudly a black flag. Periodt.",
    },
    {
      "image": "assets/images/buddy4.png",
      "name": "Yor",
      "age": 28,
      "bio": "Mommy for hire here! Can't cook but I'm good with a knife.",
    },
  ];

  final List<Map<String, dynamic>> _selectedParticipants = [];

  int get _peopleCount => 1 + _selectedParticipants.length;

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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
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

  void _showParticipantPicker() {
    final available = _allParticipants
        .where((p) => !_selectedParticipants.contains(p))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No more participants available.")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: available.length,
            itemBuilder: (context, index) {
              final participant = available[index];
              return Card(
                color: const Color(0xFF2E0B5C).withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(participant["image"]),
                    radius: 28,
                  ),
                  title: Text(
                    participant["name"],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Age: ${participant["age"]}\n${participant["bio"]}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedParticipants.add(participant);
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _increaseParticipants() {
    if (_selectedParticipants.length >= _allParticipants.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("You cannot add more than available participants.")),
      );
      return;
    }
    _showParticipantPicker();
  }

  void _decreaseParticipants() {
    if (_selectedParticipants.isNotEmpty) {
      setState(() {
        _selectedParticipants.removeLast();
      });
    }
  }

  void _removeParticipant(Map<String, dynamic> participant) {
    setState(() {
      _selectedParticipants.remove(participant);
    });
  }

  void _goToPayment() {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date & time before payment.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PaymentPage()),
    ).then((success) {
      if (success == true) {
        final dateStr =
            "${_selectedDateTime!.year}-${_selectedDateTime!.month.toString().padLeft(2, '0')}-${_selectedDateTime!.day.toString().padLeft(2, '0')}";
        final timeStr =
            "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}";

        setState(() {
          _bookingConfirmed = true; // ✅ Mark booking as confirmed
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Booking confirmed for $_peopleCount people on $dateStr at $timeStr!",
            ),
            duration: const Duration(seconds: 4),
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
            onPressed: () => Navigator.pop(context), // ✅ Close dialog
            child: const Text("Changed my mind"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentPage()),
              );
            },
            child: const Text("Pay Cancellation Fee"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDate =
        "${_scheduledEventDateTime.day} ${_monthName(_scheduledEventDateTime.month)} ${_scheduledEventDateTime.year}";
    final scheduledTime =
        "${_scheduledEventDateTime.hour > 12 ? _scheduledEventDateTime.hour - 12 : _scheduledEventDateTime.hour}:${_scheduledEventDateTime.minute.toString().padLeft(2, '0')} ${_scheduledEventDateTime.hour >= 12 ? "PM" : "AM"}";

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
                mainAxisAlignment: MainAxisAlignment.center,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.white70),
                        onPressed: _decreaseParticipants,
                      ),
                      Text(
                        "$_peopleCount",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: Colors.white70),
                        onPressed: _increaseParticipants,
                      ),
                    ],
                  ),
                  if (_selectedParticipants.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      children: _selectedParticipants
                          .map((p) => Chip(
                                avatar: CircleAvatar(
                                  backgroundImage: AssetImage(p["image"]),
                                ),
                                label: Text(
                                  p["name"],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color(0xFF2E0B5C),
                                deleteIcon: const Icon(Icons.close,
                                    color: Colors.white),
                                onDeleted: () => _removeParticipant(p),
                              ))
                          .toList(),
                    )
                  ],
                  const SizedBox(height: 20),
                  // First: Select Date Button
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
                  // Then: Pay Now Button
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
                  // ✅ Cancel Booking Button (only visible when booking confirmed)
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
