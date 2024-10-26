import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';

class SavingGoalScreen extends StatefulWidget {
  const SavingGoalScreen({super.key});
  static const String routeName = '/savings_goal';

  @override
  _SavingGoalScreenState createState() => _SavingGoalScreenState();
}

class _SavingGoalScreenState extends State<SavingGoalScreen> {
  final TextEditingController goalController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  double savedAmount = 0.0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadGoalData();
  }

  Future<void> _loadGoalData() async {
    try {
      double? goalAmount = await DatabaseHelper.instance.getGoal();
      setState(() {
        savedAmount = goalAmount ?? 0.0;
      });
    } catch (e) {
      print("Error loading goal data: $e");
    }
  }

  Future<void> _saveGoal() async {
    final String goalName = goalController.text;
    final double goalAmount = double.tryParse(amountController.text) ?? 0.0;

    if (goalAmount > 0) {
      try {
        await DatabaseHelper.instance.insertGoal(goalAmount);
        setState(() {
          savedAmount = goalAmount;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Goal "$goalName" set for \$${goalAmount.toStringAsFixed(2)}')),
        );
      } catch (e) {
        print("Error saving goal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save goal.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid goal amount.')),
      );
    }
  }

  @override
  void dispose() {
    goalController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Set and Track Your Savings Goals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (savedAmount / (double.tryParse(amountController.text) ?? 1)).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              'Progress: \$${savedAmount.toStringAsFixed(2)} / \$${(double.tryParse(amountController.text) ?? 0).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(
                labelText: 'Goal Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            Text("Deadline: ${selectedDate.toLocal()}".split(' ')[0]),
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: const Text('Select Deadline'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGoal,
              child: const Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }
}