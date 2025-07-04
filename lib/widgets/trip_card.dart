import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String date;
  final String time;
  final String startLocation;
  final String endLocation;
  final String mapImageUrl;

  const TripCard({
    super.key,
    required this.date,
    required this.time,
    required this.startLocation,
    required this.endLocation,
    required this.mapImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(minHeight: 222),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          // BoxShadow(
          // color: Colors.black.withOpacity(0.08),
          // blurRadius: 0.5,
          // offset: const Offset(0, 4),
          // ),
        ],
      ),
      child: Column(
        children: [
          // Map Image Section
          Container(
            width: 348,
            height: 142,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                mapImageUrl,
                width: 348,
                height: 142,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 348,
                    height: 142,
                    color: const Color(0xFFD9D9D9),
                    child: const Center(
                      child: Icon(
                        Icons.map,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Trip Details Section
          Container(
            width: 348,
            constraints: const BoxConstraints(minHeight: 80),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F2E3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date and Time
                  Text(
                    '$date  •  $time',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Start and End Locations
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Start Location
                      Expanded(
                        flex: 2,
                        child: Text(
                          startLocation,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans',
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Dotted Line
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: List.generate(
                                  20,
                                  (index) => Expanded(
                                    child: Container(
                                      height: 1,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: index % 2 == 0
                                            ? Colors.black
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // End Location
                      Expanded(
                        flex: 2,
                        child: Text(
                          endLocation,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Open Sans',
                            height: 1.2,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
