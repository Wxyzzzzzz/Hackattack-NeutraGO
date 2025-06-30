import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// class FootprintChart extends StatelessWidget {
//   const FootprintChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 280,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Carbon Footprint',
//             style: TextStyle(
//               color: Color(0xFF153462),
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: 250,
//                   getDrawingHorizontalLine: (value) {
//                     return FlLine(
//                       color: const Color(0xFFE5E5E5),
//                       strokeWidth: 1,
//                     );
//                   },
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       interval: 1,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         const style = TextStyle(
//                           color: Color(0xFF707070),
//                           fontWeight: FontWeight.w400,
//                           fontSize: 10,
//                         );
//                         Widget text;
//                         switch (value.toInt()) {
//                           case 0:
//                             text = const Text('13 Apr', style: style);
//                             break;
//                           case 1:
//                             text = const Text('14 Apr', style: style);
//                             break;
//                           case 2:
//                             text = const Text('15 Apr', style: style);
//                             break;
//                           case 3:
//                             text = const Text('16 Apr', style: style);
//                             break;
//                           case 4:
//                             text = const Text('17 Apr', style: style);
//                             break;
//                           case 5:
//                             text = const Text('18 Apr', style: style);
//                             break;
//                           case 6:
//                             text = const Text('19 Apr', style: style);
//                             break;
//                           default:
//                             text = const Text('', style: style);
//                             break;
//                         }
//                         return SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           child: text,
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 250,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         const style = TextStyle(
//                           color: Color(0xFF707070),
//                           fontWeight: FontWeight.w400,
//                           fontSize: 10,
//                         );
//                         return Text(value.toInt().toString(), style: style);
//                       },
//                       reservedSize: 32,
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                   show: false,
//                 ),
//                 minX: 0,
//                 maxX: 6,
//                 minY: 0,
//                 maxY: 1000,
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(0, 500),
//                       FlSpot(1, 300),
//                       FlSpot(2, 650),
//                       FlSpot(3, 400),
//                       FlSpot(4, 780),
//                       FlSpot(5, 100),
//                       FlSpot(6, 850),
//                     ],
//                     isCurved: true,
//                     gradient: LinearGradient(
//                       colors: [
//                         const Color(0xFF7A9B5A).withOpacity(0.8),
//                         const Color(0xFF7A9B5A),
//                       ],
//                     ),
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         if (index == 2 || index == 4) {
//                           return FlDotCirclePainter(
//                             radius: 4,
//                             color: const Color(0xFFFF4444),
//                             strokeWidth: 0,
//                           );
//                         }
//                         return FlDotCirclePainter(
//                           radius: 2,
//                           color: const Color(0xFF7A9B5A),
//                           strokeWidth: 0,
//                         );
//                       },
//                     ),
//                     belowBarData: BarAreaData(
//                       show: false,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class FootprintChart extends StatefulWidget {
  final String userId;
  const FootprintChart({super.key, required this.userId});
  // const FootprintChart({super.key});

  @override
  State<FootprintChart> createState() => _FootprintChartState();
}

// class _FootprintChartState extends State<FootprintChart> {
//   Future<Map<String, double>> fetchAggregatedCo2() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('trips')
//         // .where('user_id', isEqualTo: widget.userId)
//         .where('user_id', isEqualTo: 'jAENInMkzS0KvYyVSyJA')
//         .get();

//     Map<String, double> dailyTotals = {}; // key: yyyy-MM-dd, value: sum of co2

//     for (var doc in snapshot.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final co2 = (data['co2_emitted'] ?? 0).toDouble();

//       DateTime dt;

//       if (data['starttimestamp'] is Timestamp) {
//         dt = (data['starttimestamp'] as Timestamp).toDate();
//       } else if (data['starttimestamp'] is int) {
//         dt = DateTime.fromMillisecondsSinceEpoch(data['starttimestamp'] * 1000);
//       } else {
//         continue;
//       }

//       String dayKey = DateFormat('yyyy-MM-dd').format(dt);

//       dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + co2;
//     }

//     return dailyTotals;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, double>>(
//       future: fetchAggregatedCo2(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final data = snapshot.data!;
//         final sortedKeys = data.keys.toList()..sort();
//         final List<FlSpot> spots = [];
//         final Map<int, String> xLabels = {};

//         for (int i = 0; i < sortedKeys.length; i++) {
//           spots.add(FlSpot(i.toDouble(), data[sortedKeys[i]]!));
//           xLabels[i] = DateFormat('d MMM').format(DateTime.parse(sortedKeys[i]));
//         }

//         return Container(
//           height: 280,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Daily Carbon Footprint',
//                 style: TextStyle(
//                   color: Color(0xFF153462),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: LineChart(
//                   LineChartData(
//                     gridData: FlGridData(
//                       show: true,
//                       drawVerticalLine: false,
//                       horizontalInterval: 250,
//                       getDrawingHorizontalLine: (value) {
//                         return FlLine(
//                           color: const Color(0xFFE5E5E5),
//                           strokeWidth: 1,
//                         );
//                       },
//                     ),
//                     titlesData: FlTitlesData(
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           interval: 1,
//                           reservedSize: 30,
//                           getTitlesWidget: (value, meta) {
//                             const style = TextStyle(
//                               color: Color(0xFF707070),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 10,
//                             );
//                             return SideTitleWidget(
//                               axisSide: meta.axisSide,
//                               child: Text(xLabels[value.toInt()] ?? '', style: style),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           interval: 250,
//                           getTitlesWidget: (value, meta) {
//                             const style = TextStyle(
//                               color: Color(0xFF707070),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 10,
//                             );
//                             return Text(value.toInt().toString(), style: style);
//                           },
//                           reservedSize: 32,
//                         ),
//                       ),
//                       topTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       rightTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                     ),
//                     borderData: FlBorderData(show: false),
//                     minX: 0,
//                     maxX: spots.length.toDouble() - 1,
//                     minY: 0,
//                     maxY: 1000,
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: spots,
//                         isCurved: true,
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color(0xFF7A9B5A).withOpacity(0.8),
//                             const Color(0xFF7A9B5A),
//                           ],
//                         ),
//                         barWidth: 3,
//                         isStrokeCapRound: true,
//                         dotData: FlDotData(show: true),
//                         belowBarData: BarAreaData(show: false),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class _FootprintChartState extends State<FootprintChart> {
  Future<Map<String, double>> fetchAggregatedCo2() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7Days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

    // Start with 0 CO₂ for each day
    Map<String, double> dailyTotals = {
      for (var date in last7Days)
        DateFormat('yyyy-MM-dd').format(date): 0.0
    };

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trips')
        .where('user_id', isEqualTo: widget.userId)
        .get();

        // QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('trips')
//         // .where('user_id', isEqualTo: widget.userId)
//         .where('user_id', isEqualTo: 'jAENInMkzS0KvYyVSyJA')
//         .get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final co2 = (data['co2_emitted'] ?? 0).toDouble();

      DateTime dt;
      if (data['starttimestamp'] is Timestamp) {
        dt = (data['starttimestamp'] as Timestamp).toDate();
      } else if (data['starttimestamp'] is int) {
        dt = DateTime.fromMillisecondsSinceEpoch(data['starttimestamp'] * 1000);
      } else {
        continue;
      }

      String dayKey = DateFormat('yyyy-MM-dd').format(dt);
      if (dailyTotals.containsKey(dayKey)) {
        dailyTotals[dayKey] = (dailyTotals[dayKey] ?? 0) + co2;
      }
    }

    return dailyTotals;
  }

  double calculateInterval(double maxY) {
    if (maxY <= 100) return 20;
    if (maxY <= 200) return 40;
    if (maxY <= 400) return 80;
    if (maxY <= 800) return 160;
    return 200;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: fetchAggregatedCo2(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final sortedKeys = data.keys.toList()..sort();
        final List<FlSpot> spots = [];
        final Map<int, String> xLabels = {};

        for (int i = 0; i < sortedKeys.length; i++) {
          final key = sortedKeys[i];
          final value = data[key]!;
          spots.add(FlSpot(i.toDouble(), value));
          xLabels[i] = DateFormat('d MMM').format(DateTime.parse(key)); // Mon, Tue...
        }

        double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
        double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

        if (minY == maxY) {
          minY = 0;
          maxY += 50;
        } else {
          final yRange = maxY - minY;
          minY = (minY - yRange * 0.1).clamp(0, double.infinity);
          maxY = (maxY + yRange * 0.1).clamp(minY + 10, double.infinity);
        }

        return Container(
          height: 280,
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
                'Daily Carbon Footprint',
                style: TextStyle(
                  color: Color(0xFF153462),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  // padding: const EdgeInsets.only(bottom: 36), // space for x-axis labels
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6, // 7 days: 0 to 6
                      minY: minY,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: calculateInterval(maxY),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFFE5E5E5),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            // reservedSize: 10,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: Color(0xFF707070),
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              );
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8,
                                child: Text(xLabels[value.toInt()] ?? '', style: style),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: calculateInterval(maxY),
                            getTitlesWidget: (value, meta) {

                              // Hide the top label if it equals maxY
                              if (value == maxY) {
                                return const SizedBox.shrink();
                              }

                              const style = TextStyle(
                                color: Color(0xFF707070),
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              );
                              return Text(value.toInt().toString(), style: style);
                            },
                            reservedSize: 32,
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF7A9B5A).withOpacity(0.8),
                              const Color(0xFF7A9B5A),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              // Expanded(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // Fixed Y-Axis labels
              //       // Column(
              //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       //   children: List.generate(6, (i) {
              //       //     final labelValue = ((maxY - minY) / 5) * (5 - i) + minY;
              //       //     return SizedBox(
              //       //       height: 40,
              //       //       child: Text(
              //       //         labelValue.round().toString(),
              //       //         style: const TextStyle(
              //       //           fontSize: 10,
              //       //           color: Color(0xFF707070),
              //       //         ),
              //       //       ),
              //       //     );
              //       //   }),
              //       // ),
              //       // Fixed Y-axis label column

              //       Container(
              //         width: 40,
              //         height: chartHeight - 20.0,
              //         padding: const EdgeInsets.only(right: 2),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: List.generate(6, (i) {
              //             final labelValue = ((maxY - minY) / 5) * (5 - i) + minY;
              //             return Text(
              //               labelValue.round().toString(),
              //               style: const TextStyle(fontSize: 10, color: Color(0xFF707070)),
              //             );
              //           }),
              //         ),
              //       ),
              //       const SizedBox(width: 2),
              //       // Scrollable chart
              //       Expanded(
              //         child: SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: SizedBox(
              //             width: 450,
              //             height: chartHeight,
              //             child: Padding(
              //               padding: const EdgeInsets.only(bottom: 0.0),
              //               child: LineChart(
              //                 LineChartData(
              //                   minX: -0.1,
              //                   maxX: spots.length.toDouble() - 0.9,
              //                   minY: minY,
              //                   maxY: maxY,
              //                   // clipData: FlClipData.all(),
              //                   gridData: FlGridData(
              //                     show: true,
              //                     drawVerticalLine: false,                                  horizontalInterval: calculateInterval(maxY),
              //                     getDrawingHorizontalLine: (value) => FlLine(
              //                       color: const Color(0xFFE5E5E5),
              //                       strokeWidth: 1,
              //                     ),
              //                   ),
              //                   titlesData: FlTitlesData(
              //                     leftTitles: const AxisTitles(
              //                       sideTitles: SideTitles(showTitles: false, reservedSize: 32),
              //                     ),
              //                     rightTitles: const AxisTitles(
              //                       sideTitles: SideTitles(showTitles: false),
              //                     ),
              //                     topTitles: const AxisTitles(
              //                       sideTitles: SideTitles(showTitles: false),
              //                     ),
              //                     bottomTitles: AxisTitles(
              //                       sideTitles: SideTitles(                                      showTitles: true,
              //                         interval: 1,
              //                         reservedSize: 25,
              //                         getTitlesWidget: (value, meta) {
              //                           return SideTitleWidget(
              //                             axisSide: meta.axisSide,
              //                             child: Padding(
              //                               padding: const EdgeInsets.symmetric(horizontal: 4),
              //                               child: Text(
              //                                 xLabels[value.toInt()] ?? '',
              //                                 style: const TextStyle(
              //                                   fontSize: 10,
              //                                   color: Color(0xFF707070),
              //                                 ),
              //                               ),
              //                             ),
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ),
              //                   borderData: FlBorderData(show: false),
              //                   lineBarsData: [
              //                     LineChartBarData(
              //                       spots: spots,
              //                       isCurved: true,
              //                       barWidth: 3,
              //                       dotData: FlDotData(show: true),
              //                       gradient: LinearGradient(
              //                         colors: [
              //                           const Color(0xFF7A9B5A).withOpacity(0.8),
              //                           const Color(0xFF7A9B5A),
              //                         ],
              //                       ),
              //                       belowBarData: BarAreaData(show: false),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
