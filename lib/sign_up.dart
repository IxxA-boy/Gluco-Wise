import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'sign_in.dart';
import 'functional_screen_one.dart';
import 'theme_manager.dart';

class ThirdScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update user display name with full name
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

    return Scaffold(
      body: Stack(
        children: [
          // Theme-based background image
          Positioned.fill(
            child: Image.asset(
              isDarkMode
                  ? 'assets/images/image24.jpg'  // Your dark theme image
                  : 'assets/images/image25.png', // Your light theme image
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Curved Header
                  Stack(
                    children: [
                      Container(
                        height: 150,
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

                  // Form Container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
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

                        // Full Name Field
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

                        // Email Field
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

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: theme.hintColor),
                            suffixIcon: Icon(
                              Icons.visibility_off,
                              color: theme.iconTheme.color,
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

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _signUp(context),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OR Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: theme.dividerColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        const SizedBox(height: 20),

                        // Social Login Buttons
                        _buildSocialButton(
                          context,
                          icon: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                            height: 24,
                          ),
                          label: "Login with Gmail",
                        ),
                        const SizedBox(height: 10),
                        _buildSocialButton(
                          context,
                          icon: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png",
                            height: 24,
                          ),
                          label: "Login with Facebook",
                        ),
                        const SizedBox(height: 20),

                        // Sign In Link
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                              );
                            },
                            child: Text(
                              "Already have an account? Sign in",
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {required Image icon, required String label}) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.cardColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: theme.dividerColor),
          ),
        ),
        icon: icon,
        onPressed: () {},
        label: Text(
          label,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}