import 'package:flutter/material.dart';

class BudgetNotifier {
  static bool _hasShownNotification = false;

  static Future<void> showBudgetNotification(
    BuildContext context,
    double monthlySpent,
    double monthlyBudget,
  ) async {
    if (_hasShownNotification) return;
    _hasShownNotification = true;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Budget Exceeded'),
            content: Text(
              'You\'ve spent ₹${monthlySpent.toStringAsFixed(2)} this month.\n'
              'Your budget is ₹${monthlyBudget.toStringAsFixed(2)}.',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    ).then((_) {
      _hasShownNotification = false;
    });
  }
}
