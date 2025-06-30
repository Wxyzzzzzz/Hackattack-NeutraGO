import 'package:flutter/material.dart';

class CongestionTableCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String emissions;
  final Color backgroundColor;

  const CongestionTableCard({
    super.key,
    required this.icon,
    required this.title,
    required this.emissions,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 41, top: 14, right: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: icon == Icons.directions_car ? 15 : 19,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                Text(
                  emissions,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
          
          // Congestion Table
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 16),
            child: Container(
              width: 289,
              height: 102,
              decoration: BoxDecoration(
                color: const Color(0xFF367970),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  // Table Headers
                  const Positioned(
                    left: 15,
                    top: 6,
                    child: Text(
                      'Congestion Level',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 125,
                    top: 6,
                    child: Text(
                      'Speed (km/h)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 217,
                    top: 6,
                    child: Text(
                      'Adjustment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  
                  // Table Data
                  const Positioned(
                    left: 39,
                    top: 29,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Low',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Medium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'High',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    left: 129,
                    top: 29,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '≥ 60',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          '≥ 30 and <60',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          '< 30',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    left: 232,
                    top: 29,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'None',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          '+ 15%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          '+ 40%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Table separators
                  Positioned(
                    left: 114,
                    top: 10,
                    child: Container(
                      width: 1,
                      height: 85,
                      color: const Color(0xFF121212),
                    ),
                  ),
                  Positioned(
                    left: 213,
                    top: 10,
                    child: Container(
                      width: 1,
                      height: 85,
                      color: const Color(0xFF121212),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 31,
                    child: Container(
                      width: 269,
                      height: 1,
                      color: const Color(0xFF121212),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
