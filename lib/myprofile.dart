import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dashboard.dart';
import 'main.dart'; // ✅ Import LoginPage

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF2E0B5C);
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  // Controllers for editable fields
  final TextEditingController _firstNameController =
      TextEditingController(text: "John");
  final TextEditingController _lastNameController =
      TextEditingController(text: "Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john@example.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "9876543210");
  final TextEditingController _passwordController =
      TextEditingController(text: "password123");
  final TextEditingController _ageController =
      TextEditingController(text: "30");
  final TextEditingController _bioController =
      TextEditingController(text: "Love movies, food & events!");
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Dummy existing interests & addresses
  final List<String> _interests = ["Movies", "Food", "Travel", "Music", "Sports"];
  final List<String> _addresses = ["123 Main St", "456 Park Ave"]; // example addresses

  // Gender
  String? _selectedGender = "Man"; // Default selection

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select your gender")),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    }
  }

  void _deleteAccount() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false, // ✅ Removes all previous routes
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black54,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? "$label cannot be empty" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/static_loading_page.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar
                  Row(
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
                        "My Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profile picture centered
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: _primaryColor,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage("assets/images/profile_placeholder.png")
                                as ImageProvider,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: _primaryColor, width: 2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.edit, color: _primaryColor, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Editable fields
                  _buildTextField("First Name", _firstNameController),
                  const SizedBox(height: 16),
                  _buildTextField("Last Name", _lastNameController),
                  const SizedBox(height: 16),
                  _buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildTextField("Phone Number", _phoneController, keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField("Password", _passwordController, obscureText: true),
                  const SizedBox(height: 16),
                  _buildTextField("Age", _ageController, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField("Bio", _bioController),
                  const SizedBox(height: 16),

                  // ✅ Gender Selection
                  const Text(
                    "Gender",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: "Man",
                          groupValue: _selectedGender,
                          activeColor: Colors.purple,
                          title: const Text("Man", style: TextStyle(color: Colors.white)),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: "Woman",
                          groupValue: _selectedGender,
                          activeColor: Colors.purple,
                          title: const Text("Woman", style: TextStyle(color: Colors.white)),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Addresses input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Add Address",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black54,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (_addressController.text.isNotEmpty) {
                            setState(() {
                              _addresses.add(_addressController.text.trim());
                              _addressController.clear();
                            });
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Display addresses
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _addresses.removeAt(index);
                                  });
                                },
                                child: const Icon(Icons.close, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Interests input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _interestController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Add Interest",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black54,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (_interestController.text.isNotEmpty) {
                            setState(() {
                              _interests.add(_interestController.text.trim());
                              _interestController.clear();
                            });
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Display interests
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _interests.map((interest) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(interest,
                                  style: const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.purple,
                              deleteIcon: const Icon(Icons.close, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  _interests.remove(interest);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveProfile,
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Delete account button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _deleteAccount,
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
