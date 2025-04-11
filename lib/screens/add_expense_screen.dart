import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_screen/expense_form.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(
      context,
      listen: false,
    );
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: ExpenseForm(
        onSave: (title, amount, category, date) async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          try {
            final newExpense = Expense(
              title: title,
              amount: amount,
              category: category,
              date: date,
            );

            await expenseProvider.addExpense(newExpense);

            final total = expenseProvider.monthlySpent;
            final monthlyBudget = budgetProvider.monthlyBudget ?? 0.0;

            final isOver = monthlyBudget != 0 && total > monthlyBudget;

            if (!mounted) return;

            if (isOver) {
              await Future.delayed(const Duration(milliseconds: 300));

              if (!mounted) return;

              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Budget Exceeded'),
                      content: Text(
                        'You\'ve spent ₹${total.toStringAsFixed(2)} this month.\n'
                        'Your budget is ₹${monthlyBudget.toStringAsFixed(2)}.',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
              );
            }
          } catch (e) {
            debugPrint('Error while saving: $e');

            if (!mounted) return;

            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Failed to add expense.')),
            );
          }
        },
      ),
    );
  }
}
