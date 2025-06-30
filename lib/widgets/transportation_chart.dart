import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'dart:developer' as developer;

class TransportationChart extends StatefulWidget {
  // const TransportationChart({super.key});

  final String userId;

  const TransportationChart({super.key, required this.userId});

  @override
  State<TransportationChart> createState() => _TransportationChartState();

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 320,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Daily Carbon Footprint',
  //           style: TextStyle(
  //           color: Color(0xFF153462),
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Expanded(
  //           child: BarChart(
  //             BarChartData(
  //               alignment: BarChartAlignment.spaceAround,
  //               maxY: 200,
  //               barTouchData: BarTouchData(enabled: false),
  //               titlesData: FlTitlesData(
  //                 show: true,
  //                 rightTitles: const AxisTitles(
  //                   sideTitles: SideTitles(showTitles: false),
  //                 ),
  //                 topTitles: const AxisTitles(
  //                   sideTitles: SideTitles(showTitles: false),
  //                 ),
  //                 bottomTitles: AxisTitles(
  //                   sideTitles: SideTitles(
  //                     showTitles: true,
  //                     getTitlesWidget: (double value, TitleMeta meta) {
  //                       const style = TextStyle(
  //                         color: Color(0xFF707070),
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 12,
  //                       );
  //                       Widget text;
  //                       switch (value.toInt()) {
  //                         case 0:
  //                           text = const Text('Jan', style: style);
  //                           break;
  //                         case 1:
  //                           text = const Text('Feb', style: style);
  //                           break;
  //                         case 2:
  //                           text = const Text('Mar', style: style);
  //                           break;
  //                         case 3:
  //                           text = const Text('Apr', style: style);
  //                           break;
  //                         default:
  //                           text = const Text('', style: style);
  //                           break;
  //                       }
  //                       return SideTitleWidget(
  //                         axisSide: meta.axisSide,
  //                         child: text,
  //                       );
  //                     },
  //                     reservedSize: 38,
  //                   ),
  //                 ),
  //                 leftTitles: AxisTitles(
  //                   sideTitles: SideTitles(
  //                     showTitles: true,
  //                     interval: 50,
  //                     getTitlesWidget: (double value, TitleMeta meta) {
  //                       const style = TextStyle(
  //                         color: Color(0xFF707070),
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 10,
  //                       );
  //                       return Text(value.toInt().toString(), style: style);
  //                     },
  //                     reservedSize: 32,
  //                   ),
  //                 ),
  //               ),
  //               borderData: FlBorderData(show: false),
  //               barGroups: [
  //                 // January
  //                 BarChartGroupData(
  //                   x: 0,
  //                   barRods: [
  //                     BarChartRodData(
  //                       toY: 100,
  //                       rodStackItems: [
  //                         BarChartRodStackItem(0, 50, const Color(0xFFB5D3C7)),
  //                         BarChartRodStackItem(50, 80, const Color(0xFF7A9B5A)),
  //                         BarChartRodStackItem(80, 100, const Color(0xFF153462)),
  //                       ],
  //                       width: 40,
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(4),
  //                         topRight: Radius.circular(4),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // February
  //                 BarChartGroupData(
  //                   x: 1,
  //                   barRods: [
  //                     BarChartRodData(
  //                       toY: 140,
  //                       rodStackItems: [
  //                         BarChartRodStackItem(0, 60, const Color(0xFFB5D3C7)),
  //                         BarChartRodStackItem(60, 110, const Color(0xFF7A9B5A)),
  //                         BarChartRodStackItem(110, 140, const Color(0xFF153462)),
  //                       ],
  //                       width: 40,
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(4),
  //                         topRight: Radius.circular(4),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // March
  //                 BarChartGroupData(
  //                   x: 2,
  //                   barRods: [
  //                     BarChartRodData(
  //                       toY: 170,
  //                       rodStackItems: [
  //                         BarChartRodStackItem(0, 40, const Color(0xFFB5D3C7)),
  //                         BarChartRodStackItem(40, 120, const Color(0xFF7A9B5A)),
  //                         BarChartRodStackItem(120, 170, const Color(0xFF153462)),
  //                       ],
  //                       width: 40,
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(4),
  //                         topRight: Radius.circular(4),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // April
  //                 BarChartGroupData(
  //                   x: 3,
  //                   barRods: [
  //                     BarChartRodData(
  //                       toY: 190,
  //                       rodStackItems: [
  //                         BarChartRodStackItem(0, 50, const Color(0xFFB5D3C7)),
  //                         BarChartRodStackItem(50, 130, const Color(0xFF7A9B5A)),
  //                         BarChartRodStackItem(130, 190, const Color(0xFF153462)),
  //                       ],
  //                       width: 40,
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(4),
  //                         topRight: Radius.circular(4),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //               gridData: FlGridData(
  //                 show: true,
  //                 drawVerticalLine: false,
  //                 horizontalInterval: 50,
  //                 getDrawingHorizontalLine: (value) {
  //                   return FlLine(
  //                     color: const Color(0xFFE5E5E5),
  //                     strokeWidth: 1,
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         // Legend
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildLegendItem('Walking', const Color(0xFFB5D3C7)),
  //             _buildLegendItem('Driving', const Color(0xFF7A9B5A)),
  //             _buildLegendItem('Public Transit', const Color(0xFF153462)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLegendItem(String label, Color color) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Container(
  //         width: 12,
  //         height: 12,
  //         decoration: BoxDecoration(
  //           color: color,
  //           shape: BoxShape.circle,
  //         ),
  //       ),
  //       const SizedBox(width: 6),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           color: Color(0xFF707070),
  //           fontSize: 12,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class _TransportationChartState extends State<TransportationChart> {
  late Future<List<BarChartGroupData>> _barGroupsFuture;

  final List<String> months = ['Mar', 'Apr', 'May', 'June'];
  final List<Color> transportColors = [
    Color(0xFFB5D3C7), // Walk
    Color(0xFF7A9B5A), // Drive
    Color(0xFF153462), // Public
  ];

  @override
  void initState() {
    super.initState();
    _barGroupsFuture = _fetchBarGroups();
  }

  Future<List<BarChartGroupData>> _fetchBarGroups() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userId)
        .get();
    
    

    final data = docSnapshot.data();
    
    if (data == null || !data.containsKey('carbon_footprint')) {
      return [];
    }
   
    final Map<String, dynamic> footprint = Map<String, dynamic>.from(data['carbon_footprint']);

    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < months.length; i++) {
      final month = months[i];
      final monthData = footprint[month];

      if (monthData is Map<String, dynamic>) {
        double walk = (monthData['walk'] ?? 0).toDouble();
        double drive = (monthData['drive'] ?? 0).toDouble();
        double publicTransit = (monthData['public'] ?? 0).toDouble();

        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: walk + drive + publicTransit,
                rodStackItems: [
                  BarChartRodStackItem(0, walk, transportColors[0]),
                  BarChartRodStackItem(walk, walk + drive, transportColors[1]),
                  BarChartRodStackItem(walk + drive, walk + drive + publicTransit, transportColors[2]),
                ],
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        );
      }
    }

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Carbon Footprint',
            style: TextStyle(
              color: Color(0xFF153462),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<BarChartGroupData>>(
              future: _barGroupsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _calculateMaxY(snapshot.data!),
                    barGroups: snapshot.data!,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Color(0xFF707070),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            );
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                months[value.toInt()],
                                style: style,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 50,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Color(0xFF707070),
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xFFE5E5E5),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Walking', transportColors[0]),
              _buildLegendItem('Driving', transportColors[1]),
              _buildLegendItem('Public Transit', transportColors[2]),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateMaxY(List<BarChartGroupData> groups) {
    double maxY = 0;
    for (var group in groups) {
      for (var rod in group.barRods) {
        maxY = maxY < rod.toY ? rod.toY : maxY;
      }
    }
    return (maxY / 50).ceil() * 50.0;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF707070),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}