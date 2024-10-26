import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  double get totalSpending {
    return recentTransactions.fold(0.0, (sum, txn) => sum + txn.amount);
  }

  const Chart(this.recentTransactions, {super.key});

  List<Map<String, Object>> get groupedTransactionValues {
    final today = DateTime.now();
    List<double> weekSums = List<double>.filled(7, 0);

    for (Transaction txn in recentTransactions) {
      if (txn.date.isAfter(today.subtract(const Duration(days: 7)))) {
        weekSums[txn.date.weekday - 1] += txn.amount;
      }
    }

    return List.generate(7, (index) {
      final dayOfPastWeek = today.subtract(Duration(days: index));
      return {
        'day': DateFormat('E').format(dayOfPastWeek)[0],
        'amount': weekSums[dayOfPastWeek.weekday - 1],
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((value) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                value['day'] as String,
                value['amount'] as double,
                totalSpending == 0.0 ? 0.0 : (value['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}