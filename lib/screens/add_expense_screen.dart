import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense_model.dart';
import '../providers/budget_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/add_expense_screen/expense_form.dart';
import '../widgets/common/budget_notifier.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<ExpenseFormState>();

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

            final monthlySpent = expenseProvider.monthlySpent;
            final shouldNotify = await budgetProvider.shouldNotify(
              expenseDate: date,
              monthlySpent: monthlySpent,
            );
            final monthlyBudget = budgetProvider.monthlyBudget;

            if (shouldNotify && (monthlyBudget != null && monthlyBudget > 0)) {
              await BudgetNotifier.showBudgetNotification(
                context,
                monthlySpent,
                monthlyBudget,
              );
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('Error while saving: $e');
            }

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
}
