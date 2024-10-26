import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/transaction.dart';
import '../widgets/new_transaction_form.dart';
import '../widgets/transaction_list.dart';
import '../widgets/chart.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  static const String routeName = '/expense';

  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    DateTime lastWeek = DateTime.now().subtract(const Duration(days: 7));
    return _userTransactions.where((txn) => txn.date.isAfter(lastWeek)).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    setState(() {
      _userTransactions = transactions;
    });
  }

  Future<void> _addNewTransaction(
      String title, double amount, String category, DateTime date) async {
    final newTxn = Transaction(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    await DatabaseHelper.instance.insertTransaction(newTxn);
    _loadTransactions();
  }

  Future<void> _deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransactionById(id);
    _loadTransactions();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransactionForm(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text('Expense Tracker'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                ),
              ],
            ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showChart || !isLandscape
                ? SizedBox(
                    height: isLandscape ? availableHeight * 0.6 : availableHeight * 0.3,
                    child: Chart(_recentTransactions),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: TransactionList(_userTransactions, _deleteTransaction),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}