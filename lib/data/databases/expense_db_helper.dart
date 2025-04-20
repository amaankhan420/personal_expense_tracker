import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/expense_model.dart';

class ExpenseDB {
  static final ExpenseDB _instance = ExpenseDB._();
  static Database? _db;

  ExpenseDB._();

  factory ExpenseDB() => _instance;

  Future<Database> get database async {
    try {
      if (_db != null) return _db!;
      _db = await _initDB();
      return _db!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting database: $e');
      }
      rethrow;
    }
  }

  Future<Database> _initDB() async {
    try {
      final path = join(await getDatabasesPath(), 'expenses.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              amount REAL,
              category TEXT,
              date TEXT
            )
          ''');
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing database: $e');
      }
      rethrow;
    }
  }

  Future<int> insertExpense(Expense expense) async {
    try {
      final db = await database;
      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error inserting expense: $e');
      }
      return -1;
    }
  }

  Future<int> updateExpense(Expense expense) async {
    try {
      final db = await database;
      return await db.update(
        'expenses',
        expense.toMap(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating expense: $e');
      }
      return -1;
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    try {
      final db = await database;
      final res = await db.query('expenses', orderBy: 'date DESC');
      return res.map((e) => Expense.fromMap(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching expenses: $e');
      }
      return [];
    }
  }

  Future<int> deleteExpense(int id) async {
    try {
      final db = await database;
      return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error deleting expense: $e');
      }
      return 0;
    }
  }
}
