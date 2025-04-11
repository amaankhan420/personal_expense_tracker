import 'package:flutter/material.dart';

import '../common/expense_input_fields.dart';

class ExpenseForm extends StatefulWidget {
  final void Function(
    String title,
    double amount,
    String category,
    DateTime date,
  )
  onSave;

  const ExpenseForm({super.key, required this.onSave});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final category = _selectedCategory;

    if (title.isEmpty || amount <= 0 || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    try {
      widget.onSave(title, amount, category, _selectedDate);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Expense added')));
    } catch (e, stack) {
      debugPrint('Error while saving expense: $e\n$stack');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong while saving.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ExpenseInputFields(
              titleController: _titleController,
              amountController: _amountController,
              selectedCategory: _selectedCategory,
              selectedDate: _selectedDate,
              onCategoryChanged:
                  (val) => setState(() => _selectedCategory = val),
              onPickDate: _pickDate,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Add Expense'),
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
