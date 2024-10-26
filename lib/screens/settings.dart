import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  static const String routeName = '/settings';

  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  late bool _darkModeEnabled;
  String _currency = 'USD';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _darkModeEnabled = widget.isDarkMode; // Initialize with the current theme mode
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      // Load settings, replacing below with fetched values if available
      _notificationsEnabled = true;
      _currency = 'USD';
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Save notification preference logic here
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkModeEnabled = value;
      widget.onThemeChanged(value); // Trigger dark mode change in app
    });
    // Optionally save dark mode preference here
  }

  Future<void> _selectCurrency() async {
    final selectedCurrency = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Currency'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'USD'),
              child: const Text('USD'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'EUR'),
              child: const Text('EUR'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'GBP'),
              child: const Text('GBP'),
            ),
          ],
        );
      },
    );

    if (selectedCurrency != null && selectedCurrency != _currency) {
      setState(() {
        _currency = selectedCurrency;
      });
      // Optionally save currency preference here
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: _toggleDarkMode,
          ),
          ListTile(
            title: const Text('Currency'),
            subtitle: Text(_currency),
            onTap: _selectCurrency,
          ),
          const Divider(height: 40),
          const Text(
            'Account Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text('Update Account Info'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}