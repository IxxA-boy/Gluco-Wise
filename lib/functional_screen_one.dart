import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_manager.dart';
import 'sign_in.dart';
import 'functional_screen_two.dart';
import 'healthtips_screen.dart';
import 'diabetes_checkups.dart';
import 'usage_chart_screen.dart';
import 'history_screen.dart';

class FunctionalScreenOne extends StatefulWidget {
  final String firstName;

  const FunctionalScreenOne({Key? key, required this.firstName}) : super(key: key);

  @override
  _FunctionalScreenOneState createState() => _FunctionalScreenOneState();
}

class _FunctionalScreenOneState extends State<FunctionalScreenOne> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  bool _isCharging = false;

  @override
  void initState() {
    super.initState();
    _initBatteryInfo();
  }

  Future<void> _initBatteryInfo() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;

      setState(() {
        _batteryLevel = batteryLevel;
        _isCharging = batteryState == BatteryState.charging;
      });

      // Listen for battery state changes
      _battery.onBatteryStateChanged.listen((BatteryState state) {
        setState(() {
          _isCharging = state == BatteryState.charging;
        });
      });
    } catch (e) {
      print('Error initializing battery info: $e');
      setState(() {
        _batteryLevel = 0;
        _isCharging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Welcome, ${widget.firstName}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              Provider.of<ThemeManager>(
                context,
                listen: false,
              ).toggleTheme(!isDarkMode);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              _handleMenuSelection(context, value);
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
      body: Column(
        children: [
          Expanded(
            child: Container(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Track Your Food Button (Centered)
                    _buildFoodTrackingButton(),

                    // Two Buttons in One Row
                    _buildHealthButtons(),

                    // Graph Button
                    _buildDailySugarTrackerButton(),

                    // System Info Container
                    _buildSystemInfoContainer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTrackingButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FunctionalScreenTwo(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.fastfood, size: 50, color: Colors.purple),
              SizedBox(height: 10),
              Text(
                'Track Your Food',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildHealthButton(
              icon: Icons.health_and_safety,
              title: 'Health Tips',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HealthTipsScreen()),
              ),
            ),
          ),
          Expanded(
            child: _buildHealthButton(
              icon: Icons.medical_services,
              title: 'Diabetic Checkups',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiabetesCheckups()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.purple),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailySugarTrackerButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UsageChartScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.bar_chart, size: 50, color: Colors.purple),
              SizedBox(height: 10),
              Text(
                'Daily Sugar Tracker',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemInfoContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  DateFormat('HH:mm a').format(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  _isCharging ? Icons.battery_charging_full : Icons.battery_std,
                  color: _batteryLevel > 20 ? Colors.green : Colors.red,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Text(
                  '$_batteryLevel%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _batteryLevel > 20 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case "history":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen()),
        );
        break;
      case "contact_us":
        _showContactUsDialog(context);
        break;
      case "logout":
        _signOut(context);
        break;
    }
  }

  void _showContactUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Contact Us"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Customer Support"),
              Text("Email: support@example.com"),
              Text("Phone: +1 (555) 123-4567"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (Route<dynamic> route) => false,
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