import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class RewardDetailPage extends StatelessWidget {
  final String rewardId;
  final String? imageUrl;
  final String? title;
  final String? points;

  const RewardDetailPage({
    Key? key,
    required this.rewardId,
    this.imageUrl,
    this.title,
    this.points,
  }) : super(key: key);

  Future<void> _redeemReward(BuildContext context, int requiredPoints) async {
    final userId = 'jAENInMkzS0KvYyVSyJA';
    final userRef = FirebaseFirestore.instance.collection('user').doc(userId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) throw Exception('User not found');
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final int totalPoints = userData['total_points'] ?? 0;
        final int redeemPoints = userData['redeem_points'] ?? 0;
        if (totalPoints < requiredPoints) {
          throw Exception('not_enough_points');
        }
        transaction.update(userRef, {
          'total_points': totalPoints - requiredPoints,
          'redeem_points': redeemPoints + requiredPoints,
        });
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Reward successfully redeemed!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (e is Exception && e.toString().contains('not_enough_points')) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Insufficient Points'),
            content: Text('Your current points are not sufficient.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('rewards')
            .doc(rewardId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return Center(child: Text('Reward not found.'));
          }
          final int requiredPoints = data['required_points'] ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                height: 91,
                color: const Color(0xFFF3F2E4),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 48,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Color(0xFF153462)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Positioned(
                      top: 51,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF153462),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Banner image
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                ),
              ),
              // Details box (Frame 2609976)
              Center(
                child: Container(
                  width: 393,
                  height: 317,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? (data['reward_title'] ?? ''),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF153462),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          points ?? ('${data['required_points'] ?? 0} pts'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A9B5A),
                          ),
                        ),
                        SizedBox(height: 24),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              data['reward_description'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF46546A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              // Redeem button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF153462),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    onPressed: () => _redeemReward(context, requiredPoints),
                    child: Text(
                      'Redeem now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
