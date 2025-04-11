import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/categories.dart';

class ExpenseInputFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final String? selectedCategory;
  final DateTime selectedDate;
  final Function(String?) onCategoryChanged;
  final VoidCallback onPickDate;

  const ExpenseInputFields({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.onCategoryChanged,
    required this.onPickDate,
  });

  @override
  State<ExpenseInputFields> createState() => _ExpenseInputFieldsState();
}

class _ExpenseInputFieldsState extends State<ExpenseInputFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: widget.selectedCategory,
          items:
              expenseCategories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
          onChanged: widget.onCategoryChanged,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                'Date: ${DateFormat.yMMMd().format(widget.selectedDate)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            TextButton.icon(
              onPressed: widget.onPickDate,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick Date'),
            ),
          ],
        ),
      ],
    );
  }
}
