import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

// Import your other pages
import 'dashboard.dart';

late VideoPlayerController splashController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize splash video
  splashController =
      VideoPlayerController.asset('assets/videos/splash_screen.mp4');
  await splashController.initialize();
  splashController.play();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Happenin',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: VideoSplashScreen(nextScreen: const LoginPage()),
    );
  }
}

/// -------------------------
/// VIDEO SPLASH SCREEN
/// -------------------------
class VideoSplashScreen extends StatelessWidget {
  final Widget nextScreen;
  const VideoSplashScreen({super.key, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    splashController.addListener(() {
      if (splashController.value.position >=
              splashController.value.duration &&
          !splashController.value.isPlaying) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => nextScreen),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: splashController.value.size.width,
            height: splashController.value.size.height,
            child: VideoPlayer(splashController),
          ),
        ),
      ),
    );
  }
}

/// -------------------------
/// LOGIN PAGE
/// -------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 40),

                  // Username field
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Username / Email",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _showForgotPasswordDialog(context),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to Dashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DashboardPage()),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpPage()),
                        );
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext parentContext) {
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: parentContext,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Forgot Password?",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: emailController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter your registered email",
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.black45,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(parentContext),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              bool emailExists = false; // Simulate check
              Navigator.pop(parentContext);
              if (emailExists) {
                _showOtpDialog(parentContext, emailController.text.trim());
              } else {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text("Email not registered"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child:
                const Text("Send OTP", style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog(BuildContext parentContext, String email) {
    final TextEditingController otpController = TextEditingController();
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Enter OTP", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "6-digit OTP",
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.black45,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(parentContext),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              String enteredOtp = otpController.text.trim();
              bool isOtpValid = enteredOtp.length == 6;
              if (isOtpValid) {
                Navigator.pop(parentContext);
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text("OTP Verified! You can login now."),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid OTP. Try again."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child:
                const Text("Verify", style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}

// -------------------------
// SIGN UP PAGE
// -------------------------
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  bool _obscurePassword = true;

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Lists
  final List<String> _interests = [];
  final List<String> _addresses = [];

  // Gender
  String? _selectedGender;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _signUpSuccess(BuildContext context) {
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your gender"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProfile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      bio: _bioController.text.trim(),
      interests: _interests,
      profileImageUrl: _profileImage?.path ?? "",
      phoneNumber: _phoneController.text.trim(),
      address: _addresses.join(', '),
      gender: _selectedGender!,
    );

    debugPrint("UserProfile created: ${userProfile.toMap()}");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account successfully created!"),
        backgroundColor: Colors.purple,
        duration: Duration(seconds: 2),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Profile picture picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      backgroundImage:
                          _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? const Icon(Icons.add_a_photo,
                              size: 40, color: Colors.white70)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Fields
                  _buildTextField("First Name", controller: _firstNameController),
                  const SizedBox(height: 20),
                  _buildTextField("Last Name", controller: _lastNameController),
                  const SizedBox(height: 20),
                  _buildTextField("Email",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildTextField("Phone Number",
                      controller: _phoneController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 20),

                  // Gender selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Woman",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() => _selectedGender = value);
                              },
                              title: const Text("Woman",
                                  style: TextStyle(color: Colors.white)),
                              activeColor: Colors.purple,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              value: "Man",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() => _selectedGender = value);
                              },
                              title: const Text("Man",
                                  style: TextStyle(color: Colors.white)),
                              activeColor: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Address input
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField("Add Address",
                            controller: _addressController),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(address,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _addresses.removeAt(index);
                                  });
                                },
                                child:
                                    const Icon(Icons.close, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  _buildPasswordField(
                      "Password", _obscurePassword, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }, _passwordController),
                  const SizedBox(height: 20),

                  _buildTextField("Age",
                      controller: _ageController,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildTextField("Bio", controller: _bioController),
                  const SizedBox(height: 20),

                  // Interests input
                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField("Add Interest",
                              controller: _interestController)),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (_interestController.text.isNotEmpty) {
                            setState(() {
                              _interests
                                  .add(_interestController.text.trim());
                              _interestController.clear();
                            });
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests
                        .map((interest) => Chip(
                              label: Text(interest,
                                  style:
                                      const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.purple,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _signUpSuccess(context),
                      child: const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login here",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, bool obscure,
      VoidCallback toggleVisibility, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}

// -------------------------
// USER PROFILE MODEL
// -------------------------
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String bio;
  final List<String> interests;
  final String profileImageUrl;
  final String phoneNumber;
  final String address;
  final String gender; // ✅ Added gender

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.bio,
    required this.interests,
    required this.profileImageUrl,
    required this.phoneNumber,
    required this.address,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'bio': bio,
      'interests': interests,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age'] ?? 0,
      bio: map['bio'] ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      profileImageUrl: map['profileImageUrl'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}
