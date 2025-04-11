import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/budget_provider.dart';
import 'budget_dialog.dart';

class BudgetTile extends StatelessWidget {
  const BudgetTile({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return ListTile(
      title: const Text("Set Monthly Budget"),
      subtitle: Text(
        budgetProvider.limit == 0
            ? "N/A"
            : "Current: ₹${budgetProvider.limit.toStringAsFixed(2)}",
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap:
          () => showDialog(
            context: context,
            builder: (context) => const BudgetDialog(),
          ),
    );
  }
}
