import 'package:assesment/healthtips_screen.dart';
import 'package:assesment/usage_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'functional_screen_two.dart';
import 'history_screen.dart';
import 'sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diabetes_checkups.dart';
import 'theme_manager.dart';

class FunctionalScreenOne extends StatelessWidget {
  final String firstName;

  const FunctionalScreenOne({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, $firstName",
          style: TextStyle(color: theme.appBarTheme.titleTextStyle?.color),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: theme.iconTheme.color),
            onPressed: () {
              Provider.of<ThemeManager>(
                context,
                listen: false,
              ).toggleTheme(!isDarkMode);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: theme.iconTheme.color),
            onSelected: (value) {
              if (value == "history") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              } else if (value == "contact_us") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Contact Us option selected")),
                );
              } else if (value == "logout") {
                _signOut(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "history",
                  child: Text(
                    "History",
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
                PopupMenuItem(
                  value: "contact_us",
                  child: Text(
                    "Contact Us",
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
                PopupMenuItem(
                  value: "logout",
                  child: Text(
                    "Logout",
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/images/image24.jpg'
                  : 'assets/images/image25.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOptionCard(context, "Track a Food", Icons.fastfood, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FunctionalScreenTwo(),
                  ),
                );
              }),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                "Health Tips",
                Icons.health_and_safety,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HealthTipsScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                "Diabetic Checkups",
                Icons.medical_services,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiabetesCheckups()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildOptionCard(
                context,
                "Daily Sugar Tracker",
                Icons.bar_chart,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsageChartScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 5,
      color: theme.cardColor.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: theme.primaryColor),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign out: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
