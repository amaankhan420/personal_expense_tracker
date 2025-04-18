import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/categories_provider.dart';

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
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;

    // Reset selected category if it no longer exists
    if (widget.selectedCategory != null &&
        !categories.contains(widget.selectedCategory)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCategoryChanged(null);
      });
    }

    return Column(
      children: [
        TextField(
          controller: widget.titleController,
          maxLines: null, // Allow multiple lines
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: widget.amountController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount (₹)',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            prefixText: '₹ ',
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value:
              categories.contains(widget.selectedCategory)
                  ? widget.selectedCategory
                  : null,
          isExpanded: true,
          items:
              categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: widget.onCategoryChanged,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          menuMaxHeight: 300,
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Date: ${DateFormat.yMMMd().format(widget.selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: widget.onPickDate,
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick Date'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
