/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'sign_in.dart';
import 'theme_manager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailVerified = false;

  Future<void> _sendPasswordResetEmail() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isEmailVerified = true;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Re-authenticate the user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Update password
      await user.updatePassword(_newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password successfully updated'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = themeManager.isDarkMode;

    return Scaffold(
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
            child: Column(
              children: [
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
                    const Positioned(
                      top: 50,
                      left: 20,
                      child: BackButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Securely reset your password",
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Email Input
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.7,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
                              hintText: "Email address",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: _validateEmail,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Verify Email Button
                        if (!_isEmailVerified)
                          SizedBox(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _sendPasswordResetEmail,
                              child: Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                        // New Password Fields (only show after email verification)
                        if (_isEmailVerified) ...[
                          const SizedBox(height: 15),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.7,
                            ),
                            child: TextFormField(
                              controller: _newPasswordController,
                              obscureText: !_isPasswordVisible,
                              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: theme.iconTheme.color,
                                  ),
                                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                ),
                                hintText: "New Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.7,
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: theme.iconTheme.color,
                                  ),
                                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                                ),
                                hintText: "Confirm New Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: _validateConfirmPassword,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: screenWidth * 0.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _resetPassword,
                              child: Text(
                                "Reset Password",
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
