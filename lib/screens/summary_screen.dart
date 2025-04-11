import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/summary_screen/budget_overview_card.dart';
import '../widgets/summary_screen/category_breakdown.dart';
import 'analytics_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);

    final expenses = expenseProvider.expenses;

    final totalSpent = expenseProvider.monthlySpent;
    final totalBudget = budgetProvider.limit;
    final isOverBudget = budgetProvider.isOverBudget(totalSpent);

    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            expenses.isEmpty
                ? const Center(child: Text('No expenses found.'))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BudgetOverviewCard(
                      totalSpent: totalSpent,
                      totalBudget: totalBudget,
                      isOverBudget: isOverBudget,
                    ),
                    CategoryBreakdown(expenseProvider: expenseProvider),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AnalyticsScreen(
                                    categoryTotals:
                                        expenseProvider.categoryTotals,
                                    dailyTotals: expenseProvider.dailyTotals,
                                    totalAmount: totalSpent,
                                  ),
                            ),
                          );
                        },
                        child: const Text('Overall Analysis'),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
