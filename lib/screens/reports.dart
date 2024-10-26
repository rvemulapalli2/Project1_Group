import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportsScreen extends StatelessWidget {
  final double income;
  final double expenses;
  final double investments;
  final double goal;

  static const String routeName = '/reports';

  const ReportsScreen({
    required this.income,
    required this.expenses,
    required this.investments,
    required this.goal,
    super.key,
  });

  double _calculateProfitLoss() {
    return income + investments - expenses;
  }

  double _calculateEarnings() {
    return income + investments;
  }

  String _goalStatus() {
    return _calculateProfitLoss() >= goal ? "Goal Reached" : "Limit your expenses";
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Income": income,
      "Expenses": expenses,
      "Investments": investments,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16.0),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('Budget Goal', '\$${goal.toStringAsFixed(2)}'),
                _buildTableRow('Earnings This Month', '\$${_calculateEarnings().toStringAsFixed(2)}'),
                _buildTableRow('Expenses This Month', '\$${expenses.toStringAsFixed(2)}'),
                _buildStatusTableRow('Goal Status', _goalStatus()),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Distribution Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: dataMap.values.every((value) => value == 0)
                  ? Center(
                      child: Text(
                        'No data available to display',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : PieChart(
                      dataMap: dataMap,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      chartType: ChartType.ring,
                      colorList: const [Colors.green, Colors.redAccent, Colors.orangeAccent],
                      legendOptions: const LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.bottom,
                        legendTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        chartValueBackgroundColor: Colors.white54,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String field, String value) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              field,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildStatusTableRow(String field, String value) {
    Color statusColor = _calculateProfitLoss() >= goal ? Colors.green : Colors.red;

    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              field,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              value,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}