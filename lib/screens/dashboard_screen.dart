import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/transaction.dart';
import 'income.dart';
import 'expense_tracker.dart';
import 'saving_goal.dart';
import 'investment_tracker.dart';
import 'reports.dart';
import 'settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Transaction> transactions = [];
  double totalExpenses = 0.0;
  double currentGoal = 5000.0;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([_fetchTransactions(), _calculateTotalExpenses(), _fetchGoal()]);
  }

  Future<void> _fetchTransactions() async {
    final allTransactions = await dbHelper.getAllTransactions();
    setState(() {
      transactions = allTransactions;
    });
  }

  Future<void> _calculateTotalExpenses() async {
    final total = await dbHelper.calculateTotalExpenseAmount();
    setState(() {
      totalExpenses = total;
    });
  }

  Future<void> _fetchGoal() async {
    final goal = await dbHelper.getGoal();
    setState(() {
      currentGoal = goal ?? 5000.0;
    });
  }

  Future<void> _addInvestment(String title, double amount, DateTime date) async {
    final investment = Transaction(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      amount: amount,
      category: 'Investment',
      date: date,
    );
    await dbHelper.insertTransaction(investment);
    _fetchAllData();
  }

  void _navigateToReportsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsScreen(
          income: _calculateIncome(),
          expenses: totalExpenses,
          investments: _calculateInvestments(),
          goal: currentGoal,
        ),
      ),
    );
  }

  void _navigateToSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          onThemeChanged: widget.onThemeChanged,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettingsScreen,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFinancialOverview(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blueAccent.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOverviewItem('Total Expenses', totalExpenses),
                _buildOverviewItem('Savings Goal', currentGoal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, double amount) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 20,
      alignment: WrapAlignment.center,
      children: [
        _buildDashboardButton('Add Income', const IncomeScreen()),
        _buildDashboardButton('Add Expense', const ExpenseTrackerScreen()),
        _buildDashboardButton('Savings Goals', const SavingGoalScreen()),
        _buildDashboardButton('Investments', InvestmentTrackerScreen(onAddInvestment: _addInvestment)),
        ElevatedButton(
          onPressed: _navigateToReportsScreen,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Reports',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardButton(String label, Widget screen) {
    return ElevatedButton(
      onPressed: () => _navigateAndRefresh(context, screen),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.blueAccent,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Future<void> _navigateAndRefresh(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    _fetchAllData();
  }

  Widget _buildTransactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        transactions.isEmpty
            ? const Center(
                child: Text(
                  'No transactions added yet!',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction.title),
                    subtitle: Text(
                      '${transaction.category} - Amount: \$${transaction.amount.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                    ),
                  );
                },
              ),
      ],
    );
  }

  double _calculateIncome() {
    return transactions
        .where((txn) => txn.category == 'Income')
        .fold(0.0, (sum, txn) => sum + txn.amount);
  }

  double _calculateInvestments() {
    return transactions
        .where((txn) => txn.category == 'Investment')
        .fold(0.0, (sum, txn) => sum + txn.amount);
  }
}