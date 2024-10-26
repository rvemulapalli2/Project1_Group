class IncomeModel {
  double _income = 0.0;

  // Singleton pattern: Private constructor and instance
  static final IncomeModel _instance = IncomeModel._internal();

  factory IncomeModel() {
    return _instance;
  }

  IncomeModel._internal();

  // Initialize income if not already initialized
  void initialize(double initialIncome) {
    _income = initialIncome;
  }

  // Getter for current income
  double get income => _income;

  // Update income
  void updateIncome(double newIncome) {
    _income = newIncome;
  }
}