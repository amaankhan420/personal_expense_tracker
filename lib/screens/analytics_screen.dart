import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/analytics_screen/category_pie_chart.dart';
import '../widgets/analytics_screen/insight_summary.dart';
import '../widgets/analytics_screen/time_toggle_bar_chart.dart';

enum TimeGroup { day, week, month }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
    required this.categoryTotals,
    required this.dailyTotals,
    required this.totalAmount,
  });

  final Map<String, double> categoryTotals;
  final Map<DateTime, double> dailyTotals;
  final double totalAmount;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TimeGroup selectedGroup = TimeGroup.day;

  Map<String, double> getGroupedData() {
    final Map<String, double> grouped = {};

    for (var entry in widget.dailyTotals.entries) {
      DateTime date = entry.key;
      String label;

      switch (selectedGroup) {
        case TimeGroup.day:
          label = DateFormat('dd/MM').format(date);
          break;
        case TimeGroup.week:
          final weekStart = date.subtract(Duration(days: date.weekday - 1));
          final weekEnd = weekStart.add(Duration(days: 6));
          label =
              '${DateFormat('dd').format(weekStart)}–${DateFormat('dd MMM').format(weekEnd)}';
          break;
        case TimeGroup.month:
          label = DateFormat('MMM yyyy').format(date);
          break;
      }

      grouped[label] = (grouped[label] ?? 0) + entry.value;
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final totalSpent = context.watch<ExpenseProvider>().totalSpent;
    final budgetLimit = context.watch<BudgetProvider>().limit;
    final remaining = context.watch<BudgetProvider>().remaining(totalSpent);

    final highestCategory =
        widget.categoryTotals.entries.isNotEmpty
            ? widget.categoryTotals.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key
            : 'N/A';

    final groupedData = getGroupedData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            expenses.isEmpty
                ? const Center(child: Text("No data to display."))
                : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InsightsSummary(
                        totalSpent: totalSpent,
                        highestCategory: highestCategory,
                        budgetLimit: budgetLimit,
                        remaining: remaining,
                      ),
                      const SizedBox(height: 24),
                      CategoryPieChart(
                        categoryTotals: widget.categoryTotals,
                        totalSpent: totalSpent,
                      ),
                      const SizedBox(height: 24),
                      TimeToggleBarChart(
                        selectedGroup: selectedGroup,
                        onGroupChanged: (group) {
                          setState(() {
                            selectedGroup = group;
                          });
                        },
                        groupedData: groupedData,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
