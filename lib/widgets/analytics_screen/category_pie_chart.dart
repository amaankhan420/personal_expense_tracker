import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final double totalSpent;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("By Category", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections:
                  categoryTotals.entries.map((e) {
                    final percent = (e.value / totalSpent * 100)
                        .toStringAsFixed(1);
                    final showTitle = double.parse(percent) >= 5;
                    return PieChartSectionData(
                      value: e.value,
                      title: showTitle ? '${e.key}\n$percent%' : '',
                      radius: 60,
                      titleStyle: TextStyle(
                        fontSize: 11,
                        color: defaultTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
