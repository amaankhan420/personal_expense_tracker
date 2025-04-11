import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/budget_provider.dart';

class BudgetDialog extends StatelessWidget {
  const BudgetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text('Enter Monthly Budget'),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(hintText: "e.g. 10000"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final value = double.tryParse(controller.text);
            if (value != null && value >= 0) {
              Provider.of<BudgetProvider>(
                context,
                listen: false,
              ).setBudget(value);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter a valid amount")),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
