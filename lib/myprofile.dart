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
  final List<String> _addresses = ["123 Main St", "456 Park Ave"];

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
      (route) => false,
    );
  }

  // ✅ Reusable validator-based field builder
  Widget _buildValidatedField(
      String label, TextEditingController controller, String? Function(String?)? validator,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
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

                  // Profile picture
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

                  // Editable fields with validations
                  _buildValidatedField("First Name", _firstNameController,
                      (v) => v == null || v.isEmpty ? "Enter first name" : null),
                  const SizedBox(height: 16),

                  _buildValidatedField("Last Name", _lastNameController,
                      (v) => v == null || v.isEmpty ? "Enter last name" : null),
                  const SizedBox(height: 16),

                  _buildValidatedField("Email", _emailController, (v) {
                    if (v == null || v.isEmpty) return "Enter email";
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return "Enter valid email";
                    return null;
                  }, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),

                  _buildValidatedField("Phone Number", _phoneController, (v) {
                    if (v == null || v.isEmpty) return "Enter phone number";
                    if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                      return "Phone number must be exactly 10 digits";
                    }
                    return null;
                  }, keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),

                  _buildValidatedField("Password", _passwordController, (v) {
                    if (v == null || v.isEmpty) return "Enter password";
                    if (v.length < 8) return "Password must be at least 8 characters";
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                        .hasMatch(v)) {
                      return "Must contain letters and numbers";
                    }
                    return null;
                  }, obscureText: true),
                  const SizedBox(height: 16),

                  _buildValidatedField("Age", _ageController, (v) {
                    if (v == null || v.isEmpty) return "Enter age";
                    final age = int.tryParse(v);
                    if (age == null || age <= 0 || age > 120) {
                      return "Enter valid age";
                    }
                    return null;
                  }, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),

                  _buildValidatedField("Bio", _bioController,
                      (v) => v == null || v.isEmpty ? "Enter bio" : null),
                  const SizedBox(height: 16),

                  // ✅ Gender
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
                            final newAddress = _addressController.text.trim();
                            if (!_addresses.contains(newAddress)) {
                              setState(() {
                                _addresses.add(newAddress);
                                _addressController.clear();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Address already exists")),
                              );
                            }
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
                            final newInterest = _interestController.text.trim();
                            if (!_interests.contains(newInterest)) {
                              setState(() {
                                _interests.add(newInterest);
                                _interestController.clear();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Interest already exists")),
                              );
                            }
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
