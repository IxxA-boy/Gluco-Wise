import 'package:flutter/material.dart';

class DiabetesCheckups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diabetes Checkups"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Checkup Sections with Custom Image Sizes
          _buildSection(
            context,
            "Doctor Visits",
            "See your diabetes care provider every 3 to 6 months for regular checkups.",
            "image23.jpg",
            imageHeight: 200,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Dental Checkups",
            "Visit a dentist every 6 months to prevent gum disease.",
            "image17.jpg",
            imageHeight: 180,
            imageWidth: 350,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Eye Examinations",
            "Get an annual eye exam to check for diabetic eye diseases.",
            "image19.jpg",
            imageHeight: 220,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Foot Care",
            "Have an annual foot exam to check for nerve damage.",
            "image21.jpg",
            imageHeight: 200,
            imageWidth: 300,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Hemoglobin A1C Testing",
            "Measures average blood sugar levels over 3 months.",
            "image20.jpg",
            imageHeight: 190,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Cholesterol Testing",
            "A fasting cholesterol test should be done yearly.",
            "image22.jpg",
            imageHeight: 170,
            imageWidth: 280,
            fit: BoxFit.contain,
          ),
          _buildSection(
            context,
            "Kidney Function Tests",
            "Annual urine and blood tests check kidney health.",
            "image18.jpg",
            imageHeight: 210,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),

          // Medical Centers Header
          Padding(
            padding: EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              "Recommended Medical Centers",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          // Medical Centers with Custom Image Sizes
          _buildMedicalCenter(
            "City Diabetes Clinic",
            "123 Main Street",
            "(555) 123-4567",
            "assets/images/clinic1.jpg",
            imageHeight: 150,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),
          _buildMedicalCenter(
            "Metro Endocrine Center",
            "456 Health Avenue",
            "(555) 987-6543",
            "assets/images/clinic2.jpg",
            imageHeight: 180,
            imageWidth: 320,
            fit: BoxFit.contain,
          ),
          _buildMedicalCenter(
            "Sunrise Diabetes Care",
            "789 Wellness Road",
            "(555) 456-7890",
            "assets/images/clinic3.jpg",
            imageHeight: 170,
            imageWidth: double.infinity,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // Checkup Section Builder
  Widget _buildSection(
      BuildContext context,
      String title,
      String description,
      String imagePath, {
        double imageHeight = 180,
        double imageWidth = double.infinity,
        BoxFit fit = BoxFit.contain,
      }) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            color: Colors.grey[200], // Background color for empty space
            alignment: Alignment.center,
            child: Image.asset(
              imagePath,
              fit: fit,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Medical Center Builder
  Widget _buildMedicalCenter(
      String name,
      String address,
      String phone,
      String imagePath, {
        double imageHeight = 150,
        double imageWidth = double.infinity,
        BoxFit fit = BoxFit.contain,
      }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            color: Colors.grey[200], // Background color for empty space
            alignment: Alignment.center,
            child: Image.asset(
              imagePath,
              fit: fit,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(address),
                SizedBox(height: 4),
                Text("Phone: $phone"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}