import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

void showFilterDialog({
  required BuildContext context,
  required double? currentMin,
  required double? currentMax,
  required DateTime? currentMonth,
  required Function(double?, double?, DateTime?) onApply,
  required VoidCallback onClear,
}) {
  final expenses = context.read<ExpenseProvider>().expenses;
  final availableMonthYearPairs =
      expenses.map((e) => DateTime(e.date.year, e.date.month)).toSet().toList()
        ..sort((a, b) => b.compareTo(a));

  final minController = TextEditingController(
    text: currentMin != null ? currentMin.toString() : '',
  );
  final maxController = TextEditingController(
    text: currentMax != null ? currentMax.toString() : '',
  );

  DateTime? selectedMonth = currentMonth;

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text("Filter Expenses"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min ₹'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: maxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max ₹'),
                ),
                const SizedBox(height: 10),
                DropdownButton<DateTime>(
                  isExpanded: true,
                  hint: const Text("Select Month"),
                  value: selectedMonth,
                  onChanged: (val) => selectedMonth = val,
                  items:
                      availableMonthYearPairs.map((dt) {
                        return DropdownMenuItem(
                          value: dt,
                          child: Text(DateFormat.yMMMM().format(dt)),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onClear();
                Navigator.pop(context);
              },
              child: const Text("Clear All"),
            ),
            TextButton(
              onPressed: () {
                final min = double.tryParse(minController.text);
                final max = double.tryParse(maxController.text);
                onApply(min, max, selectedMonth);
                Navigator.pop(context);
              },
              child: const Text("Apply"),
            ),
          ],
        ),
  );
}
