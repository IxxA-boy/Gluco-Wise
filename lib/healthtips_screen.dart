import 'package:flutter/material.dart';


class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Tips"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: healthTips.length,
        itemBuilder: (context, index) {
          final tip = healthTips[index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.asset(
                    tip.imagePath,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    tip.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// HealthTip Model
class HealthTip {
  final String imagePath;
  final String description;

  HealthTip({required this.imagePath, required this.description});
}


// List of Health Tips
final List<HealthTip> healthTips = [
  HealthTip(
    imagePath: 'assets/health_tips/tip1.jpg',
    description:
    "1. Drink plenty of water daily to stay hydrated and support overall health.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip2.jpg',
    description:
    "2. Eat a balanced diet rich in fruits, vegetables, and whole grains.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip3.jpg',
    description:
    "3. Exercise regularly to maintain a healthy weight and improve cardiovascular health.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip4.jpg',
    description:
    "4. Get at least 7-8 hours of sleep each night for optimal health.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip5.jpg',
    description:
    "5. Avoid smoking and limit alcohol consumption to reduce health risks.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip6.jpg',
    description:
    "6. Manage stress through meditation, yoga, or other relaxation techniques.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip7.jpg',
    description:
    "7. Wash your hands frequently to prevent the spread of germs and infections.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip8.jpg',
    description:
    "8. Limit processed foods and sugar intake to maintain a healthy diet.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip9.jpg',
    description:
    "9. Schedule regular health checkups to monitor your overall health.",
  ),
  HealthTip(
    imagePath: 'assets/health_tips/tip10.jpg',
    description:
    "10. Practice good posture to prevent back pain and improve breathing.",
  ),
];