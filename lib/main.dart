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
                    alignment: Alignment.center,
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
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.black.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_reset, size: 60, color: Colors.purple),
              const SizedBox(height: 15),
              const Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your registered email to receive an OTP",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Email field
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white38, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.purple, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(parentContext),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white70)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
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
                    child: const Text("Send OTP"),
                  ),
                ],
              )
            ],
          ),
        ),
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

/// -------------------------
/// SIGN UP PAGE
/// -------------------------
/// -------------------------
/// SIGN UP PAGE
/// -------------------------
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
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

  // Phone verification
  final String _generatedOtp = "123456"; // Dummy OTP
  bool _isPhoneVerified = false;
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    setState(() {
      _isPhoneValid = RegExp(r'^\d{10}$').hasMatch(_phoneController.text.trim());
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _sendOtpToPhone() {
    if (!_isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid 10-digit phone number first."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint("Sending OTP $_generatedOtp to ${_phoneController.text.trim()}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("OTP sent to ${_phoneController.text.trim()} (simulated)."),
        backgroundColor: Colors.purple,
      ),
    );

    _showPhoneVerificationDialog(context);
  }

  void _showPhoneVerificationDialog(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Verify Phone Number",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "An OTP has been sent to your phone number.",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter 6-digit OTP",
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black45,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              if (otpController.text.trim() == _generatedOtp) {
                setState(() {
                  _isPhoneVerified = true;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Phone number verified successfully!"),
                    backgroundColor: Colors.purple,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
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

  void _signUpSuccess(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your gender"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isPhoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please verify your phone number before signing up"),
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

    Navigator.pop(context); // Back to login after signup
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
            child: Form(
              key: _formKey,
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

                    // Fields with validation
                    _buildValidatedField("First Name", _firstNameController,
                        (v) => v!.isEmpty ? "Enter first name" : null),
                    const SizedBox(height: 20),
                    _buildValidatedField("Last Name", _lastNameController,
                        (v) => v!.isEmpty ? "Enter last name" : null),
                    const SizedBox(height: 20),
                    _buildValidatedField(
                        "Email", _emailController, (v) {
                      if (v == null || v.isEmpty) return "Enter email";
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(v)) return "Enter valid email";
                      return null;
                    },
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),

                    _buildValidatedField("Phone Number", _phoneController,
                        (v) {
                      if (v == null || v.isEmpty) {
                        return "Enter phone number";
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                        return "Phone number must be exactly 10 digits";
                      }
                      return null;
                    }, keyboardType: TextInputType.phone),
                    const SizedBox(height: 10),

                    // Verify Phone button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPhoneValid && !_isPhoneVerified
                              ? Colors.purple
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isPhoneValid && !_isPhoneVerified
                            ? _sendOtpToPhone
                            : null,
                        child: Text(
                          _isPhoneVerified
                              ? "Phone Verified"
                              : "Verify Phone Number",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    _buildPasswordField("Password", _passwordController),
                    const SizedBox(height: 20),

                    _buildValidatedField("Age", _ageController, (v) {
                      if (v == null || v.isEmpty) return "Enter age";
                      final age = int.tryParse(v);
                      if (age == null || age <= 0 || age > 120) {
                        return "Enter valid age";
                      }
                      return null;
                    }, keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    _buildValidatedField("Bio", _bioController,
                        (v) => v!.isEmpty ? "Enter bio" : null),
                    const SizedBox(height: 20),

                    // Interests
                    Row(
                      children: [
                        Expanded(
                            child: _buildValidatedField(
                                "Add Interest", _interestController, (v) => null)),
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
                      onPressed: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildValidatedField(
      String label, TextEditingController controller, String? Function(String?)? validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      validator: validator,
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

  Widget _buildPasswordField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: _obscurePassword,
      validator: (v) {
        if (v == null || v.isEmpty) return "Enter password";
        if (v.length < 8) return "Password must be at least 8 characters";
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
            .hasMatch(v)) {
          return "Must contain letters and numbers";
        }
        return null;
      },
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
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}

/// -------------------------
/// USER PROFILE MODEL
/// -------------------------
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
  final String gender;

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
