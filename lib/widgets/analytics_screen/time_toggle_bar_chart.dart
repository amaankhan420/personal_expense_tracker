import 'dart:math' as math;

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

    double ceiling;
    if (maxVal < 10) {
      ceiling = (maxVal / 2).ceil() * 2;
    } else if (maxVal < 100) {
      ceiling = (maxVal / 20).ceil() * 20;
    } else if (maxVal < 1000) {
      ceiling = (maxVal / 200).ceil() * 200;
    } else if (maxVal < 10000) {
      ceiling = (maxVal / 2000).ceil() * 2000;
    } else {
      ceiling = (maxVal / 20000).ceil() * 20000;
    }

    return math.max(ceiling, maxVal * 1.1);
  }

  double _getIntervalSize(double maxY) {
    const targetIntervals = 5;
    return maxY / targetIntervals;
  }

  @override
  Widget build(BuildContext context) {
    final groupedKeys = groupedData.keys.toList();
    final textScale = MediaQuery.textScaleFactorOf(context);
    final minWidth = MediaQuery.of(context).size.width * 0.8;
    final maxY = _getMaxY(groupedData);
    final intervalSize = _getIntervalSize(maxY);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          height: 300 * textScale,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: math.max(groupedKeys.length * 85.0 * textScale, minWidth),
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.teal,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.all(8),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
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
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: intervalSize,
                    checkToShowHorizontalLine: (value) {
                      return value % intervalSize < 0.01 ||
                          (value - intervalSize / 2) % intervalSize < 0.01;
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40 * textScale,
                        interval: intervalSize,
                        getTitlesWidget: (value, meta) {
                          if (value == maxY &&
                              value - intervalSize < maxY * 0.9) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
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
                          return const SizedBox.shrink();
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
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
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
                  groupsSpace: groupedKeys.length == 1 ? minWidth / 3 : 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
