import 'package:flutter/material.dart';

class InsightsSummary extends StatelessWidget {
  final double totalSpent;
  final String highestCategory;
  final double budgetLimit;
  final double remaining;

  const InsightsSummary({
    super.key,
    required this.totalSpent,
    required this.highestCategory,
    required this.budgetLimit,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Insights", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text("💰 Total Overall Spent: ₹${totalSpent.toStringAsFixed(2)}"),
        Text("📈 Highest Overall Category: $highestCategory"),
        if (budgetLimit != 0) ...[
          Text("🎯 Current Budget: ₹${budgetLimit.toStringAsFixed(2)}"),
        ],
      ],
    );
  }
}
