import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../screens/analytics_screen.dart';

class TimeToggleBarChart extends StatelessWidget {
  final TimeGroup selectedGroup;
  final Function(TimeGroup) onGroupChanged;
  final Map<String, double> groupedData;

  const TimeToggleBarChart({
    super.key,
    required this.selectedGroup,
    required this.onGroupChanged,
    required this.groupedData,
  });

  double _getMaxY(Map<String, double> data) {
    if (data.isEmpty) return 10;
    final maxVal = data.values.reduce((a, b) => a > b ? a : b);

    final magnitude = (maxVal ~/ 10000) * 10000;
    int base = 10000;
    if (magnitude >= 100000) {
      base = 100000;
    } else if (magnitude >= 10000) {
      base = 10000;
    } else if (magnitude >= 1000) {
      base = 1000;
    }
    return ((maxVal / base).ceil()) * base.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final groupedKeys = groupedData.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "By ${selectedGroup.name[0].toUpperCase()}${selectedGroup.name.substring(1)}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ToggleButtons(
              isSelected: [
                selectedGroup == TimeGroup.day,
                selectedGroup == TimeGroup.week,
                selectedGroup == TimeGroup.month,
              ],
              onPressed: (index) => onGroupChanged(TimeGroup.values[index]),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Day"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Week"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Month"),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: groupedKeys.length * 85,
              child: BarChart(
                BarChartData(
                  maxY: _getMaxY(groupedData),
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.teal,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₹${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < groupedKeys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                groupedKeys[index],
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      groupedData.entries.toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final value = entry.value.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              width: 18,
                              color: const Color(0xFF676F8A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
