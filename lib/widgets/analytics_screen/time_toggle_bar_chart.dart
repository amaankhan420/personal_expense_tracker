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

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

  double _getMaxY(Map<String, double> data) {
    if (data.isEmpty) return 10;
    final maxVal = data.values.reduce((a, b) => a > b ? a : b);

    if (maxVal < 100) {
      return ((maxVal / 10).ceil() * 10).toDouble();
    } else if (maxVal < 1000) {
      return ((maxVal / 100).ceil() * 100).toDouble();
    } else if (maxVal < 10000) {
      return ((maxVal / 1000).ceil() * 1000).toDouble();
    } else {
      return ((maxVal / 10000).ceil() * 10000).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedKeys = groupedData.keys.toList();
    final textScale = MediaQuery.textScaleFactorOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "By ${selectedGroup.name[0].toUpperCase()}${selectedGroup.name.substring(1)}",
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
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
          height: 250 * textScale,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: groupedKeys.length * 85.0 * textScale,
              child: BarChart(
                BarChartData(
                  maxY: _getMaxY(groupedData),
                  minY: 0,
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
                        reservedSize: 50 * textScale,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatNumber(value),
                                style: TextStyle(fontSize: 10 * textScale),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40 * textScale,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index < groupedKeys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: SizedBox(
                                width: 60 * textScale,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    groupedKeys[index],
                                    style: TextStyle(fontSize: 10 * textScale),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
                              width: 18 * textScale,
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
