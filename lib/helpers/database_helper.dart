import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as txn;
import '../models/investment.dart' as inv;

// Database table and column names
const String tableTransactions = 'transactions';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnAmount = 'amount';
const String columnCategory = 'category';
const String columnDate = 'date';

const String tableIncomes = 'incomes';
const String tableGoals = 'goals';
const String tableInvestments = 'investments';

// Singleton class to manage the database
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database properties
  static const _databaseName = "transactionsDB.db";
  static const _databaseVersion = 10;
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Open the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableIncomes (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableGoals (
        $columnId INTEGER PRIMARY KEY,
        $columnAmount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableInvestments (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  // Transaction helper methods
  Future<int> insertTransaction(txn.Transaction transaction) async {
    final db = await database;
    return await db?.insert(tableTransactions, transaction.toMap()) ?? 0;
  }

  Future<txn.Transaction?> getTransactionById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db?.query(
      tableTransactions,
      columns: [columnId, columnTitle, columnAmount, columnCategory, columnDate],
      where: '$columnId = ?',
      whereArgs: [id],
    ) ?? [];

    if (res.isNotEmpty) {
      return txn.Transaction.fromMap(res.first);
    }
    return null;
  }

  Future<List<txn.Transaction>> getAllTransactions() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db?.query(
      tableTransactions,
      columns: [columnId, columnTitle, columnAmount, columnCategory, columnDate],
    ) ?? [];
    return res.map((e) => txn.Transaction.fromMap(e)).toList();
  }

  Future<double> calculateTotalExpenseAmount() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db?.query(
      tableTransactions,
      columns: [columnAmount],
    ) ?? [];
    return res.fold<double>(0.0, (double sum, row) {
      final amount = double.tryParse(row[columnAmount]?.toString() ?? '0') ?? 0.0;
      return sum + amount;
    });
  }

  Future<int> deleteTransactionById(int id) async {
    final db = await database;
    return await db?.delete(
      tableTransactions,
      where: '$columnId = ?',
      whereArgs: [id],
    ) ?? 0;
  }

  // Investment helper methods
  Future<int> insertInvestment(inv.Investment investment) async {
    final db = await database;
    return await db?.insert(tableInvestments, investment.toMap()) ?? 0;
  }

  Future<List<inv.Investment>> getAllInvestments() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db?.query(
      tableInvestments,
      columns: [columnId, columnTitle, columnAmount, columnDate],
    ) ?? [];
    return res.map((e) => inv.Investment.fromMap(e)).toList();
  }

  Future<double> calculateTotalInvestmentAmount() async {
    final db = await database;
    List<Map<String, dynamic>> res = await db?.query(
      tableInvestments,
      columns: [columnAmount],
    ) ?? [];
    return res.fold<double>(0.0, (double sum, row) {
      final amount = double.tryParse(row[columnAmount]?.toString() ?? '0') ?? 0.0;
      return sum + amount;
    });
  }

  Future<int> deleteInvestmentById(int id) async {
    final db = await database;
    return await db?.delete(
      tableInvestments,
      where: '$columnId = ?',
      whereArgs: [id],
    ) ?? 0;
  }

  // Income and Goal helper methods
  Future<int> insertIncome(double amount) async {
    final db = await database;
    return await db?.insert(tableIncomes, {columnAmount: amount}) ?? 0;
  }

  Future<double?> getIncome() async {
    final db = await database;
    final res = await db?.query(tableIncomes, columns: [columnAmount]);
    return res?.isNotEmpty == true ? res!.first[columnAmount] as double : null;
  }

  Future<void> updateIncome(double amount) async {
    final db = await database;
    await db?.update(tableIncomes, {columnAmount: amount});
  }

  Future<int> insertGoal(double amount) async {
    final db = await database;
    return await db?.insert(tableGoals, {columnAmount: amount}) ?? 0;
  }

  Future<double?> getGoal() async {
    final db = await database;
    final res = await db?.query(tableGoals, columns: [columnAmount]);
    return res?.isNotEmpty == true ? res!.first[columnAmount] as double : null;
  }

  Future<void> updateGoal(double amount) async {
    final db = await database;
    await db?.update(tableGoals, {columnAmount: amount});
  }
}