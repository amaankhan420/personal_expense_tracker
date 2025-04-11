import 'package:flutter/material.dart';

import '../../models/expense_model.dart';
import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('No matching expenses.'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => ExpenseCard(expense: expenses[index]),
    );
  }
}
