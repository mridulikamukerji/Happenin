import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

// Import dashboard.dart
import 'dashboard.dart';

late VideoPlayerController splashController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

// -------------------------
// LOGIN PAGE
// -------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username field
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Username",
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
                  const SizedBox(height: 30),

                  // Login button → Navigate to Dashboard
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

                  // Sign Up button → navigates to SignUpPage
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
                      child: const Text("Sign Up with Email"),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Google button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/google_logo.png",
                        height: 24,
                      ),
                      label: const Text("Continue with Google"),
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
  final TextEditingController _addressController = TextEditingController(); // ✅ address
  final List<String> _interests = [];

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _signUpSuccess(BuildContext context) {
    final userProfile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      bio: _bioController.text.trim(),
      interests: _interests,
      profileImageUrl: _profileImage?.path ?? "",
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(), // ✅ added
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
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
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? const Icon(Icons.add_a_photo,
                                      size: 40, color: Colors.white70)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // First Name
                          _buildTextField("First Name",
                              controller: _firstNameController),
                          const SizedBox(height: 20),

                          // Last Name
                          _buildTextField("Last Name",
                              controller: _lastNameController),
                          const SizedBox(height: 20),

                          // Email
                          _buildTextField("Email",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress),
                          const SizedBox(height: 20),

                          // Phone
                          _buildTextField("Phone Number",
                              controller: _phoneController,
                              keyboardType: TextInputType.phone),
                          const SizedBox(height: 20),

                          // Address ✅
                          _buildTextField("Address",
                              controller: _addressController,
                              keyboardType: TextInputType.streetAddress),
                          const SizedBox(height: 20),

                          // Password
                          _buildPasswordField("Password", _obscurePassword, () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          }, _passwordController),
                          const SizedBox(height: 20),

                          // Age
                          _buildTextField("Age",
                              controller: _ageController,
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 20),

                          // Bio
                          _buildTextField("Bio", controller: _bioController),
                          const SizedBox(height: 20),

                          // Interests input
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField("Add Interest",
                                    controller: _interestController),
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

                          Flexible(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _interests
                                    .map((interest) => Chip(
                                          label: Text(interest),
                                          backgroundColor: Colors.purple,
                                          labelStyle:
                                              const TextStyle(color: Colors.white),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Sign Up button
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

                          // Already have account? Login
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Reusable text field
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

  // Reusable password field
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
          icon: Icon(
            obscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
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
  final String address; // ✅ added

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
      'address': address, // ✅ added
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
      address: map['address'] ?? '', // ✅ added
    );
  }
}
