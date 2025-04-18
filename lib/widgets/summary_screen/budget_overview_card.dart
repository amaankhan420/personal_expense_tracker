import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetOverviewCard extends StatelessWidget {
  final double totalSpent;
  final double totalBudget;
  final bool isOverBudget;

  const BudgetOverviewCard({
    super.key,
    required this.totalSpent,
    required this.totalBudget,
    required this.isOverBudget,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalBudget - totalSpent;
    final monthLabel = DateFormat.yMMMM().format(DateTime.now());
    final defaultTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Budget Overview - $monthLabel",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _tile(
              context: context,
              icon: Icons.attach_money,
              title: 'Total Spent',
              value: '₹${totalSpent.toStringAsFixed(2)}',
              defaultColor: defaultTextColor,
            ),
            const SizedBox(height: 8),
            _tile(
              context: context,
              icon: Icons.account_balance_wallet,
              title: 'Monthly Budget',
              value:
                  totalBudget > 0
                      ? '₹${totalBudget.toStringAsFixed(2)}'
                      : 'Not Set',
              defaultColor: defaultTextColor,
            ),
            const SizedBox(height: 8),
            _tile(
              context: context,
              icon: Icons.track_changes,
              title: isOverBudget ? 'Over Budget' : 'Remaining Budget',
              value:
                  totalBudget > 0
                      ? '₹${(isOverBudget ? (totalSpent - totalBudget) : remaining).toStringAsFixed(2)}'
                      : 'N/A',
              valueColor: isOverBudget ? Colors.red : Colors.green,
              defaultColor: defaultTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    required Color defaultColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 4,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor ?? defaultColor,
              ),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }
}
