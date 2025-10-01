import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dashboard.dart';
import 'chats.dart';
import 'shorts.dart';
import 'stories.dart';
import 'invitesbooking.dart'; // ✅ Import booking page

class OpenInvitesPage extends StatefulWidget {
  const OpenInvitesPage({super.key});

  @override
  State<OpenInvitesPage> createState() => _OpenInvitesPageState();
}

class _OpenInvitesPageState extends State<OpenInvitesPage>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _openSubTabController;

  final Color _slideColor = const Color(0xFF2E0B5C);

  String _genderFilter = "No Preferences"; // Default filter

  // ✅ Open Invites categories
  final List<Map<String, dynamic>> _categories = [
    {
      "label": "For You",
      "events": [
        {
          "image": "assets/images/spotlight1.png",
          "title": "Music Festival",
          "description": "Experience live performances this weekend!",
          "date": "20 Sep 2025",
          "time": "7:00 PM",
          "venue": "Central Park",
          "rating": 4,
          "gender": "Man",
        },
        {
          "image": "assets/images/spotlight2.png",
          "title": "Art Workshop",
          "description": "Unleash your creativity at our art workshop.",
          "date": "22 Sep 2025",
          "time": "3:00 PM",
          "venue": "Art Studio",
          "rating": 5,
          "gender": "Woman",
        },
      ],
    },
    {"label": "Dining", "events": []},
    {"label": "Movies", "events": []},
    {"label": "Events", "events": []},
    {"label": "Activities", "events": []},
  ];

  // ✅ Private Invites
  final List<Map<String, dynamic>> _privateInvites = [
    {
      "image": "assets/images/spotlight1.png",
      "title": "Private Dinner",
      "description": "An exclusive dining experience with a 5-course meal.",
      "date": "21 Sep 2025",
      "time": "8:00 PM",
      "venue": "Luxury Restaurant",
      "rating": 5,
    },
    {
      "image": "assets/images/spotlight2.png",
      "title": "VIP Movie Night",
      "description": "Private screening of the latest blockbuster.",
      "date": "24 Sep 2025",
      "time": "7:30 PM",
      "venue": "Private Theatre",
      "rating": 4,
    },
    {
      "image": "assets/images/spotlight3.png",
      "title": "Private Yacht Party",
      "description": "Luxury yacht evening with live DJ and cocktails.",
      "date": "30 Sep 2025",
      "time": "6:00 PM",
      "venue": "Harbor Bay",
      "rating": 5,
    },
  ];

  // ✅ Dummy people list for private invites
  final List<Map<String, String>> people = [
    {"name": "Alice", "image": "assets/images/spotlight1.png"},
    {"name": "Bob", "image": "assets/images/spotlight2.png"},
    {"name": "Charlie", "image": "assets/images/spotlight3.png"},
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _openSubTabController =
        TabController(length: _categories.length, vsync: this);
  }

  List<Map<String, dynamic>> _applyGenderFilter(
      List<Map<String, dynamic>> events) {
    if (_genderFilter == "Men Only") {
      return events.where((e) => e["gender"] == "Man").toList();
    } else if (_genderFilter == "Women Only") {
      return events.where((e) => e["gender"] == "Woman").toList();
    }
    return events; // No Preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Invites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _slideColor,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(95),
          child: Column(
            children: [
              // ✅ Gender Filter Toggle
              Container(
                color: _slideColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleButtons(
                  isSelected: [
                    _genderFilter == "Men Only",
                    _genderFilter == "Women Only",
                    _genderFilter == "No Preferences",
                  ],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) {
                        _genderFilter = "Men Only";
                      } else if (index == 1) {
                        _genderFilter = "Women Only";
                      } else {
                        _genderFilter = "No Preferences";
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  fillColor: const Color(0xFF5D2A84),
                  selectedColor: Colors.white,
                  color: Colors.white70,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Men Only"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Women Only"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("No Preferences"),
                    ),
                  ],
                ),
              ),
              // ✅ Tabs
              TabBar(
                controller: _mainTabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: "Open Invites"),
                  Tab(text: "Private Invites"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: TabBarView(
          controller: _mainTabController,
          children: [
            // ✅ Open Invites
            Column(
              children: [
                Material(
                  color: _slideColor,
                  child: TabBar(
                    controller: _openSubTabController,
                    isScrollable: false,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: _categories
                        .map((c) => Tab(text: c["label"].toString()))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _openSubTabController,
                    children: _categories.map((category) {
                      final events = _applyGenderFilter(
                          List<Map<String, dynamic>>.from(category["events"]));
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: events.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return _buildEventCard(context, event);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // ✅ Private Invites
            ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _privateInvites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final event = _privateInvites[index];
                return _buildEventCard(context, event);
              },
            ),
          ],
        ),
      ),

      // ✅ Floating Add Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          bool isPrivate = _mainTabController.index == 1;
          _openAddEventModal(isPrivate);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      );
  }

  // ✅ Event Card
  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    final int rating = event["rating"] ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: _slideColor.withOpacity(0.85),
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
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: event["image"].toString().startsWith("assets/")
                ? Image.asset(
                    event["image"],
                    fit: BoxFit.cover,
                    height: 160,
                    width: double.infinity,
                  )
                : Image.file(
                    File(event["image"]),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event["title"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(event["date"],
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        Text(event["time"],
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(event["description"],
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 6),
                Text("Venue: ${event["venue"]}",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 22,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvitesBookingPage(
                            title: event["title"],
                            image: event["image"],
                            description: event["description"],
                          ),
                        ),
                      );
                    },
                    child: const Text("Join",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Add Event Modal (with category dropdown & validation)
  void _openAddEventModal(bool isPrivate) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController venueController = TextEditingController();
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();

    String gender = "No Preference";
    List<Map<String, String>> selectedPeople = [];
    File? pickedImage;
    String category = "Dining";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _slideColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      isPrivate
                          ? "Add Private Invite"
                          : "Add Open Invite",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // ✅ Image Picker
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setModalState(() {
                          pickedImage = File(image.path);
                        });
                      }
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: pickedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                pickedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Text("Tap to select image",
                                  style: TextStyle(color: Colors.white70)),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Category Dropdown
                  DropdownButtonFormField<String>(
                    value: category,
                    dropdownColor: Colors.black87,
                    decoration: _inputDecoration("Category"),
                    items: ["Dining", "Movies", "Events", "Activities"]
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setModalState(() => category = value!),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Event Name"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Description"),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Date & Time Row
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.purpleAccent,
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF2E0B5C),
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: Colors.black87,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                dateController.text =
                                    "${picked.day}/${picked.month}/${picked.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: dateController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("Start Date"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.purpleAccent,
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF2E0B5C),
                                      onSurface: Colors.white,
                                    ),
                                    dialogBackgroundColor: Colors.black87,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                timeController.text =
                                    "${picked.day}/${picked.month}/${picked.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: timeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("End Date"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.purpleAccent,
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF2E0B5C),
                                      onSurface: Colors.white,
                                    ),
                                    timePickerTheme: TimePickerThemeData(
                                      backgroundColor: Colors.black87,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                startTimeController.text = picked.format(context);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: startTimeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("Start Time"),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.purpleAccent,
                                      onPrimary: Colors.white,
                                      surface: Color(0xFF2E0B5C),
                                      onSurface: Colors.white,
                                    ),
                                    timePickerTheme: TimePickerThemeData(
                                      backgroundColor: Colors.black87,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setModalState(() {
                                endTimeController.text = picked.format(context);
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: endTimeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("End Time"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), 

                  // ✅ Venue
                  TextField(
                    controller: venueController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Venue"),
                  ),
                  const SizedBox(height: 12),

                  // ✅ Gender selection for Open Invites
                  if (!isPrivate)
                    DropdownButtonFormField<String>(
                      value: gender,
                      dropdownColor: Colors.black87,
                      decoration: _inputDecoration("Gender Preference"),
                      items: ["Man", "Woman", "No Preference"]
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g,
                                    style: const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setModalState(() => gender = value!),
                    ),

                  // ✅ Participant selection for Private Invites
                  if (isPrivate) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      label: const Text("Add Participants",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final List<Map<String, String>>? picked =
                            await showModalBottomSheet(
                          context: context,
                          backgroundColor: _slideColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            List<bool> tempSelected =
                                List.filled(people.length, false);
                            return StatefulBuilder(
                                builder: (context, setSheetState) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Select Friends",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: people.length,
                                        itemBuilder: (context, i) {
                                          return CheckboxListTile(
                                            value: tempSelected[i],
                                            onChanged: (val) {
                                              setSheetState(() {
                                                tempSelected[i] = val!;
                                              });
                                            },
                                            activeColor: Colors.purpleAccent,
                                            title: Text(people[i]['name']!,
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                            secondary: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  people[i]['image']!),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.purpleAccent),
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          people
                                              .asMap()
                                              .entries
                                              .where((e) => tempSelected[e.key])
                                              .map((e) => e.value)
                                              .toList()
                                              .cast<Map<String, String>>(), // ✅ Fixed type
                                        );
                                      },
                                      child: const Text("Done",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );

                        if (picked != null) {
                          setModalState(() {
                            selectedPeople = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    if (selectedPeople.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: selectedPeople
                            .map((p) => Chip(
                                  avatar: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(p['image']!),
                                  ),
                                  label: Text(p['name']!,
                                      style: const TextStyle(
                                          color: Colors.white)),
                                  backgroundColor:
                                      Colors.black.withOpacity(0.4),
                                ))
                            .toList(),
                      )
                  ],

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: () {
                      // ✅ Validation
                      if (titleController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          timeController.text.isEmpty ||
                          venueController.text.isEmpty ||
                          pickedImage == null ||
                          (!isPrivate && gender.isEmpty) ||
                          (category.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please fill all mandatory fields (except Description)"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Map<String, dynamic> newEvent = {
                        "title": titleController.text,
                        "description": descriptionController.text,
                        "date": dateController.text,
                        "time": timeController.text,
                        "venue": venueController.text,
                        "image": pickedImage?.path ??
                            "assets/images/spotlight1.png",
                        "rating": 0,
                      };
                      if (!isPrivate) {
                        newEvent["gender"] = gender;
                        newEvent["category"] = category;
                        int catIndex = _categories.indexWhere(
                            (c) => c["label"] == category);
                        if (catIndex != -1) {
                          _categories[catIndex]["events"].add(newEvent);
                        }
                      } else {
                        newEvent["participants"] = selectedPeople;
                        _privateInvites.add(newEvent);
                      }
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Add Event",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
