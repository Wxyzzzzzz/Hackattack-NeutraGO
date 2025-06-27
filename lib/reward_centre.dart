import 'package:flutter/material.dart';

class RewardsCentrePage extends StatelessWidget {
  const RewardsCentrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          // Header background
          Container(
            width: double.infinity,
            height: 100,
            color: const Color(0xFFF3F2E4),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 91,
                  color: const Color(0xFFF3F2E4),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F2E4),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 52,
                  child: Center(
                    child: Text(
                      'Rewards Centre',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF153462),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rectangle box for user points
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF22866E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFFFFAF44), size: 32),
                  SizedBox(width: 30),
                  Text(
                    'Your Points: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '1,250',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Popular Merchants (horizontally scrollable)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            child: SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: const [
                  _MerchantCircle(name: 'Starbucks'),
                  SizedBox(width: 24),
                  _MerchantCircle(name: 'McDonalds'),
                  SizedBox(width: 24),
                  _MerchantCircle(name: 'KFC'),
                  SizedBox(width: 24),
                  _MerchantCircle(name: 'Pizzahut'),
                  SizedBox(width: 24),
                  _MerchantCircle(name: 'Tealive'),
                  SizedBox(width: 24),
                  _MerchantCircle(name: 'FamilyMart'),
                ],
              ),
            ),
          ),
          // Promo & Rewards
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Promo & Rewards',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF153462),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PromoListPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF22866E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 230, // Height to fit the promo card
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                final promos = [
                  {
                    'image':
                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                    'title': 'Pizza Hut RM 10 off',
                    'points': '300 pts',
                    'color': Color(0xFFBADCBC),
                    'subtitleColor': Color(0xFF3F8167),
                  },
                  {
                    'image':
                        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
                    'title': 'Pizza Hut RM 10 off',
                    'points': '300 pts',
                    'color': Color(0xFFBADCBC),
                    'subtitleColor': Color(0xFF3F8167),
                  },
                  {
                    'image':
                        'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
                    'title': '7-Eleven RM 2 Cashback',
                    'points': '100 pts',
                    'color': Color(0xFFBADCBC),
                    'subtitleColor': Color(0xFF3F8167),
                  },
                ];
                final promo = promos[index];
                return SizedBox(
                  width: 260,
                  child: PromoCard(
                    image: promo['image'] as String,
                    title: promo['title'] as String,
                    points: promo['points'] as String,
                    color: promo['color'] as Color,
                    subtitleColor: promo['subtitleColor'] as Color,
                  ),
                );
              },
            ),
          ),
          // Rewards List
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          //     children: const [
          //       _RewardPromoCard(
          //         merchant: 'Starbucks',
          //         title: 'Get a Free Coffee from Starbucks',
          //         points: 280,
          //         color: Color(0xFFFFAF44),
          //       ),
          //       SizedBox(height: 16),
          //       _RewardPromoCard(
          //         merchant: 'Pizza Hut',
          //         title: 'Pizza Hut RM 10 off',
          //         points: 300,
          //         color: Color(0xFF7A9B5A),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _MerchantCircle extends StatelessWidget {
  final String name;
  const _MerchantCircle({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.store, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _RewardPromoCard extends StatelessWidget {
  final String merchant;
  final String title;
  final int points;
  final Color color;
  const _RewardPromoCard(
      {required this.merchant,
      required this.title,
      required this.points,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color,
              child: Icon(Icons.card_giftcard, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('$points pts',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF153462))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromoListPage extends StatelessWidget {
  const PromoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F2E4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF153462)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Promo',
          style: TextStyle(
            color: Color(0xFF153462),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          PromoCard(
            image:
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            title: 'Get a Free Coffee from Starbucks',
            points: '280 pts',
            color: Color(0xFFBADCBC),
            subtitleColor: Color(0xFF3F8167),
          ),
          SizedBox(height: 24),
          PromoCard(
            image:
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            title: 'Pizza Hut RM 10 off',
            points: '300 pts',
            color: Color(0xFFBADCBC),
            subtitleColor: Color(0xFF3F8167),
          ),
          SizedBox(height: 24),
          PromoCard(
            image:
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
            title: '7-Eleven RM 2 Cashback',
            points: '100 pts',
            color: Color(0xFFBADCBC),
            subtitleColor: Color(0xFF3F8167),
          ),
          SizedBox(height: 24),
          PromoCard(
            image:
                'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
            title: 'TNG RM 1 Cashback',
            points: '50 pts',
            color: Color(0xFFBADCBC),
            subtitleColor: Color(0xFF3F8167),
          ),
        ],
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String image;
  final String title;
  final String points;
  final Color color;
  final Color subtitleColor;

  const PromoCard({
    Key? key,
    required this.image,
    required this.title,
    required this.points,
    required this.color,
    required this.subtitleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              image,
              height: 143,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    points,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.63),
                      fontSize: 14,
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