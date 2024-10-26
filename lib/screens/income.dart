import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/income_model.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  static const String routeName = '/income';

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final IncomeModel incomeModel = IncomeModel(); 
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIncomeFromDatabase();
  }

  Future<void> _loadIncomeFromDatabase() async {
    try {
      double? savedIncome = await DatabaseHelper.instance.getIncome();
      if (savedIncome != null) {
        incomeModel.updateIncome(savedIncome);
      } else {
        incomeModel.initialize(0.0); 
      }
      setState(() {});
    } catch (e) {
      print('Error loading income: $e');
    }
  }

  Future<void> _saveIncome(BuildContext context) async {
    double newIncome = double.tryParse(amountController.text) ?? 0.0;
    incomeModel.updateIncome(newIncome);

    double? savedIncome = await DatabaseHelper.instance.getIncome();

    try {
      if (savedIncome != null) {
        await DatabaseHelper.instance.updateIncome(newIncome);
      } else {
        await DatabaseHelper.instance.insertIncome(newIncome);
      }
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Income saved: \$${newIncome.toStringAsFixed(2)}')),
      );
    } catch (error) {
      print('Error saving income: $error');
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display current income in a rounded card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.blueAccent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Current Income',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${incomeModel.income.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Input for new income amount
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Enter New Income',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),

            // Save Income Button
            ElevatedButton(
              onPressed: () => _saveIncome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save Income',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}