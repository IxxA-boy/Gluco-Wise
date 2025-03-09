import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'theme_manager.dart';

class UsageChartScreen extends StatefulWidget {
  const UsageChartScreen({Key? key}) : super(key: key);

  @override
  State<UsageChartScreen> createState() => _UsageChartScreenState();
}

class _UsageChartScreenState extends State<UsageChartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DateTimeRange _dateRange;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  final double _dailySugarGoal = 25.0;

  final DateFormat _dateFormat = DateFormat('MMM dd');
  final DateFormat _fullDateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));
    _dateRange = DateTimeRange(start: startDate, end: endDate);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final query = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('products')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(_dateRange.start))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(_dateRange.end))
          .orderBy('timestamp', descending: true);

      final snapshot = await query.get();
      setState(() {
        _products = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      await _loadProducts();
    }
  }

  List<BarChartGroupData> _prepareChartData() {
    final Map<DateTime, double> dailySugar = {};

    for (final product in _products) {
      final timestamp = product['timestamp'] as Timestamp?;
      if (timestamp == null || product['sugarLevel'] == null) continue;

      final date = timestamp.toDate();
      final sugar = double.tryParse(product['sugarLevel'].toString()) ?? 0;

      dailySugar.update(date, (value) => value + sugar, ifAbsent: () => sugar);
    }

    final sortedDates = dailySugar.keys.toList()..sort();

    return sortedDates.map((date) {
      return BarChartGroupData(
        x: date.millisecondsSinceEpoch,
        barRods: [
          BarChartRodData(
            toY: dailySugar[date]!,
            color: dailySugar[date]! > _dailySugarGoal ? Colors.red : Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final totalSugar = _products.fold<double>(0.0, (sum, product) {
      final sugar = double.tryParse(product['sugarLevel']?.toString() ?? '0') ?? 0;
      return sum + sugar;
    });
    final averageDailySugar = _products.isNotEmpty
        ? totalSugar / (_dateRange.duration.inDays + 1)
        : 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Sugar Consumption Chart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(context),
            tooltip: 'Select date range',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              themeManager.isDarkMode
                  ? 'assets/images/image24.jpg'
                  : 'assets/images/image25.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Range: ${_fullDateFormat.format(_dateRange.start)} to ${_fullDateFormat.format(_dateRange.end)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: themeManager.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_dateRange.duration.inDays + 1} days shown',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: themeManager.isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Transparent container for graph
                Container(
                  decoration: BoxDecoration(
                    color: themeManager.isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: themeManager.isDarkMode
                          ? Colors.white24
                          : Colors.black12,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeManager.isDarkMode
                            ? Colors.black26
                            : Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 350, // Increased height to accommodate labels
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : _products.isEmpty
                            ? const Text('No data available')
                            : BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.center,
                              barGroups: _prepareChartData(),
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 86400000, // 1 day in milliseconds
                                    reservedSize: 40, // Increase space for titles
                                    getTitlesWidget: (value, meta) {
                                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _dateFormat.format(date),
                                          style: TextStyle(
                                            color: themeManager.isDarkMode ? Colors.white : Colors.black,
                                            fontSize: 10, // Slightly smaller font
                                            overflow: TextOverflow.visible,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                  axisNameWidget: Text(
                                    'Date',
                                    style: TextStyle(
                                      color: themeManager.isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toStringAsFixed(1)}g',
                                        style: TextStyle(
                                          color: themeManager.isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                  axisNameWidget: Text(
                                    'Sugar (g)',
                                    style: TextStyle(
                                      color: themeManager.isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: themeManager.isDarkMode
                                      ? Colors.white24
                                      : Colors.black26,
                                  strokeWidth: 1,
                                ),
                                getDrawingVerticalLine: (value) => FlLine(
                                  color: themeManager.isDarkMode
                                      ? Colors.white24
                                      : Colors.black26,
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: themeManager.isDarkMode
                                      ? Colors.white24
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: themeManager.isDarkMode
                      ? Colors.grey[800]?.withOpacity(0.6)
                      : Colors.white.withOpacity(0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Sugar:',
                              style: TextStyle(
                                color: themeManager.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              '${totalSugar.toStringAsFixed(1)}g',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeManager.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daily Average:',
                              style: TextStyle(
                                color: themeManager.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              '${averageDailySugar.toStringAsFixed(1)}g',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: averageDailySugar > _dailySugarGoal
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recommended Daily Limit:',
                              style: TextStyle(
                                color: themeManager.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              '${_dailySugarGoal}g',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}