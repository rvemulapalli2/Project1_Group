import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/income.dart';
import 'screens/expense_tracker.dart';
import 'screens/saving_goal.dart';
import 'screens/investment_tracker.dart';
import 'screens/reports.dart';
import 'screens/settings.dart';

void main() {
  runApp(const PersonalFinanceManagerApp());
}

class PersonalFinanceManagerApp extends StatefulWidget {
  const PersonalFinanceManagerApp({super.key});

  @override
  State<PersonalFinanceManagerApp> createState() => _PersonalFinanceManagerAppState();
}

class _PersonalFinanceManagerAppState extends State<PersonalFinanceManagerApp> {
  bool isDarkMode = false;

  void toggleDarkMode(bool enabled) {
    setState(() {
      isDarkMode = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Manager',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(
          onThemeChanged: toggleDarkMode,
          isDarkMode: isDarkMode,
        ),
        IncomeScreen.routeName: (context) => const IncomeScreen(),
        ExpenseTrackerScreen.routeName: (context) => const ExpenseTrackerScreen(),
        SavingGoalScreen.routeName: (context) => const SavingGoalScreen(),
        InvestmentTrackerScreen.routeName: (context) => InvestmentTrackerScreen(
          onAddInvestment: (title, amount, date) {
            print('Investment added: $title, $amount, $date');
          },
        ),
        ReportsScreen.routeName: (context) => ReportsScreen(
          income: 5000.0,
          expenses: 2000.0,
          investments: 1000.0,
          goal: 7000.0,
        ),
        SettingsScreen.routeName: (context) => SettingsScreen(
          onThemeChanged: toggleDarkMode,
          isDarkMode: isDarkMode,
        ),
      },
    );
  }
}