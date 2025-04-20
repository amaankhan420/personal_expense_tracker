import 'package:flutter/material.dart';

import '../common/expense_input_fields.dart';

class ExpenseForm extends StatefulWidget {
  final Function(String, double, String, DateTime) onSave;

  const ExpenseForm({super.key, required this.onSave});

  @override
  ExpenseFormState createState() => ExpenseFormState();
}

class ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  void clearFields() {
    setState(() {
      _titleController.clear();
      _amountController.clear();
      _selectedCategory = null;
      _selectedDate = DateTime.now();
    });
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (title == '' || amount <= 0 || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    widget.onSave(title, amount, _selectedCategory!, _selectedDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ExpenseInputFields(
                        titleController: _titleController,
                        amountController: _amountController,
                        selectedCategory: _selectedCategory,
                        selectedDate: _selectedDate,
                        onCategoryChanged: (newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        onPickDate: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Add Expense'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
