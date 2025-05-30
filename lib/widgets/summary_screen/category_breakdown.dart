import 'package:flutter/material.dart';

import '../../../providers/expense_provider.dart';

class CategoryBreakdown extends StatelessWidget {
  final ExpenseProvider expenseProvider;

  const CategoryBreakdown({super.key, required this.expenseProvider});

  @override
  Widget build(BuildContext context) {
    final categoryTotals = expenseProvider.getMonthlyCategoryTotals();

    if (categoryTotals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text('No expenses this month.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Category Breakdown (This Month)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...categoryTotals.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 15),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    '₹${entry.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
