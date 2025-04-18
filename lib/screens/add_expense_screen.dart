import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/budget_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_screen/expense_form.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<ExpenseFormState>();
  bool _hasShownNotification = false;

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _formKey.currentState?.clearFields(),
            tooltip: 'Clear form',
          ),
        ],
      ),
      body: ExpenseForm(
        key: _formKey,
        onSave: (title, amount, category, date) async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          try {
            if (!categoryProvider.categories.contains(category)) {
              throw Exception('Selected category no longer exists');
            }

            final newExpense = Expense(
              title: title,
              amount: amount,
              category: category,
              date: date,
            );

            await expenseProvider.addExpense(newExpense);
            _formKey.currentState?.clearFields();

            if (!mounted) return;

            final shouldNotify = await budgetProvider.shouldNotify();

            if (shouldNotify) {
              final monthlySpent = expenseProvider.monthlySpent;

              await _showBudgetNotification(
                context,
                monthlySpent,
                budgetProvider.monthlyBudget ?? 0.0,
              );
            }
          } catch (e) {
            debugPrint('Error while saving: $e');
            if (!mounted) return;

            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  e.toString().contains('no longer exists')
                      ? 'Selected category was deleted. Please choose another.'
                      : 'Failed to add expense.',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showBudgetNotification(
    BuildContext context,
    double monthlySpent,
    double monthlyBudget,
  ) async {
    if (_hasShownNotification) return;
    _hasShownNotification = true;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Budget Exceeded'),
            content: Text(
              'You\'ve spent ₹${monthlySpent.toStringAsFixed(2)} this month.\n'
              'Your budget is ₹${monthlyBudget.toStringAsFixed(2)}.',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    ).then((_) {
      _hasShownNotification = false;
    });
  }
}
