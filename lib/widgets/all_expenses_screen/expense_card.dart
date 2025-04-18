import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/expense_model.dart';
import '../../providers/categories_provider.dart';
import '../../providers/expense_provider.dart';
import '../../screens/edit_expense_screen.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.money),
        title: Text(expense.title),
        subtitle: Text(
          '${expense.category} • ₹${expense.amount.toStringAsFixed(2)}\n'
          '${DateFormat.yMMMd().format(expense.date)}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExpenseScreen(expense: expense),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<ExpenseProvider>().deleteExpense(expense.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;

  const EditExpenseDialog({super.key, required this.expense});

  @override
  State<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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

  void _save() async {
    final newTitle = _titleController.text.trim();
    final newAmount = double.tryParse(_amountController.text.trim());

    if (newTitle.isEmpty || newAmount == null || newAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid input'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedExpense = widget.expense.copyWith(
      title: newTitle,
      amount: newAmount,
      category: _selectedCategory,
      date: _selectedDate,
    );

    await context.read<ExpenseProvider>().updateExpense(
      widget.expense.id.toString(),
      updatedExpense,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense updated!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    return AlertDialog(
      title: const Text('Edit Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items:
                  categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Date'),
                  onPressed: _pickDate,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
