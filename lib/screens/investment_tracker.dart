import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class InvestmentTrackerScreen extends StatefulWidget {
  final Function(String title, double amount, DateTime date) onAddInvestment;

  const InvestmentTrackerScreen({super.key, required this.onAddInvestment});
  static const String routeName = '/investment_tracker';

  @override
  State<InvestmentTrackerScreen> createState() => _InvestmentTrackerScreenState();
}

class _InvestmentTrackerScreenState extends State<InvestmentTrackerScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<FlSpot> chartData = [
    const FlSpot(1, 200),
    const FlSpot(2, 400),
    const FlSpot(3, 300),
    const FlSpot(4, 500),
    const FlSpot(5, 700),
  ];

  void _submitInvestment() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final String title = titleController.text;

    if (title.isNotEmpty && amount > 0) {
      widget.onAddInvestment(title, amount, selectedDate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Investment added successfully')),
      );
      Navigator.pop(context); // Close screen after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid investment details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Investment Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Log a New Investment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Investment Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Investment Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text("Date: ${DateFormat.yMMMd().format(selectedDate)}"),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitInvestment,
              child: const Text('Submit Investment'),
            ),
            const SizedBox(height: 32),

            // Investment Insights
            const Divider(),
            const Text(
              'Investment Performance Chart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Line Chart Display
            Container(
              height: 250,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(
                          'Day ${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  gridData: const FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      color: Colors.blue,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}