import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'sign_in.dart';
import 'functional_screen_one.dart';
import 'theme_manager.dart';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await userCredential.user?.updateDisplayName(_fullNameController.text.trim());
        String firstName = _fullNameController.text.trim().split(" ")[0];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FunctionalScreenOne(firstName: firstName),
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to sign up: ${e.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) return "Please enter a valid email address";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters long";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDarkMode = themeManager.isDarkMode;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDarkMode
                  ? 'assets/images/image24.jpg'
                  : 'assets/images/image25.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1),
              colorBlendMode: BlendMode.overlay,
            ),
          ),

          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150, // Maintained height
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 15,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: theme.appBarTheme.iconTheme?.color),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),

                // Increased container height and reduced width
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  width: screenWidth * 0.9, // Increased to 90% of screen width
                  height: screenHeight * 0.75, // Added height to stretch the container
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Create an account here",
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Form fields
                          TextFormField(
                            controller: _fullNameController,
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              labelStyle: TextStyle(color: theme.hintColor),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Full Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            decoration: InputDecoration(
                              labelText: "Email address",
                              labelStyle: TextStyle(color: theme.hintColor),
                            ),
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 15),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(color: theme.hintColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: theme.iconTheme.color,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 10),

                          Text(
                            "By signing up you agree with our Terms of Use",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Buttons with reduced width
                          Center(
                            child: SizedBox(
                              width: screenWidth * 0.6, // Reduced to 60% of screen width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () => _signUp(context),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // OR Divider
                          Center(
                            child: SizedBox(
                              width: screenWidth * 0.6,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Social buttons with reduced width
                          Center(
                            child: SizedBox(
                              width: screenWidth * 0.6,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                                  foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                                  side: BorderSide(
                                    color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Login with Google",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Center(
                            child: SizedBox(
                              width: screenWidth * 0.6,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                                  foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                                  side: BorderSide(
                                    color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png",
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Login with Facebook",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: isDarkMode ? Colors.yellow[200] : Colors.deepPurple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                                );
                              },
                              child: const Text(
                                "Already have an account? Sign in",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}