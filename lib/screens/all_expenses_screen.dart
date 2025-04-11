import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/all_expenses_screen/expenses_list.dart';
import '../widgets/all_expenses_screen/filter_dialog.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  double? _minAmount;
  double? _maxAmount;
  DateTime? _selectedMonthYear;

  void _showFilterDialog() {
    showFilterDialog(
      context: context,
      currentMin: _minAmount,
      currentMax: _maxAmount,
      currentMonth: _selectedMonthYear,
      onApply: (min, max, month) {
        setState(() {
          _minAmount = min;
          _maxAmount = max;
          _selectedMonthYear = month;
        });
      },
      onClear: () {
        setState(() {
          _minAmount = null;
          _maxAmount = null;
          _selectedMonthYear = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allExpenses = context.watch<ExpenseProvider>().expenses;

    final filteredExpenses =
        allExpenses.where((e) {
          final matchMin = _minAmount == null || e.amount >= _minAmount!;
          final matchMax = _maxAmount == null || e.amount <= _maxAmount!;
          final matchMonth =
              _selectedMonthYear == null ||
              (e.date.month == _selectedMonthYear!.month &&
                  e.date.year == _selectedMonthYear!.year);
          return matchMin && matchMax && matchMonth;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: ExpenseList(expenses: filteredExpenses),
    );
  }
}
