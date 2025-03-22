import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'second_screen.dart'; // Import the second screen file
import 'sign_in.dart'; // Import the sign-in screen file

void main() async {

  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        primarySwatch: Colors.green, // Set the primary color theme
      ),
      home: const FirstScreen(), // First screen
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();

    // Automatically navigate to the second screen after 5 seconds
    Future.delayed(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondScreen()),
      );
    });
  }

  void loadAsset() async {
    try {
      final data = await rootBundle.load('assets/image16.png');
      print('Asset loaded successfully');
    } catch (e) {
      print('Failed to load asset: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          // Background image
          Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'image16.png',
                ),
                fit: BoxFit.contain, // Ensures the image covers the entire background
              ),
            ),
          ),
          // Centered text
          /*const Center(
            child: Text(
              'GLUCO-WISE',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),*/
      ),
    );
  }
}