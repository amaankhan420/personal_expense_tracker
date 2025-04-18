import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories_provider.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final TextEditingController _categoryController = TextEditingController();

  void _addCategory() {
    final input = _categoryController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    final categoryProvider = context.read<CategoryProvider>();
    final alreadyExists = categoryProvider.categories.any(
      (cat) => cat.toLowerCase() == input.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Category already exists')));
      return;
    }

    categoryProvider.addCategory(input);
    _categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = categoryProvider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'New Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    child: ListTile(
                      title: Text(category),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          if (categories.length == 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'There should be at least one category',
                                ),
                              ),
                            );
                          } else {
                            categoryProvider.removeCategory(category);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Reset to Default'),
                        content: const Text(
                          'Are you sure you want to reset categories to default values?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            child: const Text('Confirm'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  await categoryProvider.resetToDefault();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Categories reset to default'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset to Default'),
            ),
          ],
        ),
      ),
    );
  }
}
