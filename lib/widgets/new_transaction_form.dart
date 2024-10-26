import 'package:flutter/material.dart';

class NewTransactionForm extends StatefulWidget {
  final Function(String, double, String, DateTime) onSubmit;

  const NewTransactionForm(this.onSubmit, {super.key});

  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'General';
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    'General',
    'Groceries',
    'Rent',
    'Utilities',
    'Entertainment',
    'Investment',
  ];

  void _submitData() {
    final enteredTitle = titleController.text.trim();
    final enteredAmount = double.tryParse(amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount')),
      );
      return;
    }

    widget.onSubmit(
      enteredTitle,
      enteredAmount,
      selectedCategory,
      selectedDate,
    );

    Navigator.of(context).pop(); // Close the modal
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Enter transaction title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount in USD',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: categories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Date: ${selectedDate.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: _presentDatePicker,
                child: const Text('Select Date'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}