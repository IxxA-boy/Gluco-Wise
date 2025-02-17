import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up.dart'; // Import the sign-up screen file
import 'functional_screen_one.dart'; // Import the FunctionalScreenOne file

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for form validation
  bool _isPasswordVisible = false; // Track password visibility

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Only proceed if the form is valid
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print("User signed in: ${userCredential.user!.email}");

        // Fetch the user's display name (first name) from Firebase
        String? firstName = userCredential.user?.displayName?.split(" ")[0];

        // Navigate to FunctionalScreenOne after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FunctionalScreenOne(
              firstName: firstName ?? "User",
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        print("Failed to sign in: ${e.message}");
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to sign in: ${e.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Associate the form key
          child: Column(
            children: [
              // Curved Green Header
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.25, // 25% of screen height
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sign In Text
              const Text(
                "Sign in",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome back...!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // Email Input Field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, // 10% of screen width
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Email address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validateEmail, // Email validation
                ),
              ),

              const SizedBox(height: 20),

              // Password Input Field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, // 10% of screen width
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible, // Toggle visibility
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off // Show "hide" icon
                            : Icons.visibility, // Show "show" icon
                      ),
                      onPressed: () {
                        // Toggle password visibility
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: _validatePassword, // Password validation
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.green),
                ),
              ),

              const SizedBox(height: 20),

              // Sign In Button
              SizedBox(
                width: screenWidth * 0.5, // 50% of screen width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => _signIn(context),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // OR Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 50, height: 1, color: Colors.grey),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Container(width: 50, height: 1, color: Colors.grey),
                ],
              ),

              const SizedBox(height: 20),

              // Google Sign-In
              SizedBox(
                width: screenWidth * 0.7, // 70% of screen width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  icon: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {},
                  label: const Text("Login with Gmail",
                      style: TextStyle(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 10),

              // Facebook Sign-In
              SizedBox(
                width: screenWidth * 0.7, // 70% of screen width
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  icon: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png",
                    width: 20,
                    height: 20,
                  ),
                  onPressed: () {},
                  label: const Text("Login with Facebook",
                      style: TextStyle(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New member? "),
                  TextButton(
                    onPressed: () {
                      // Navigate to Third Screen (Sign-Up Screen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThirdScreen()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}