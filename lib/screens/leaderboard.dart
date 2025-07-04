import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  // Placeholder user data
  final List<Map<String, dynamic>> userItems = [
    {"rank": "4", "image": "assets/a.png", "name": "Jones", "point": 300},
    {"rank": "5", "image": "assets/b.png", "name": "YOU", "point": 285},
    {"rank": "6", "image": "assets/c.png", "name": "Jenny", "point": 200},
    {"rank": "7", "image": "assets/d.png", "name": "Kevin", "point": 120},
    {"rank": "8", "image": "assets/e.jpeg", "name": "Alfred", "point": 20},
    // Add more users...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFF5F3E3),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF153462)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Center(
                  child: Text(
                    'Leaderboard',
                    style: const TextStyle(
                      color: Color(0xFF153462),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 3,
                    color: const Color(0xFF153462),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Top background image with avatars overlayed
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 375 / 280, // Adjust to your image's aspect ratio
                child: Image.asset(
                  "assets/leaderboard1.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              // Top 3 avatars (customize positions as needed)
              Positioned(
                top: 30,
                left: MediaQuery.of(context).size.width / 2 - 45,
                child: _rankAvatar("assets/g.jpeg", "Jennifer", "7200", 45),
              ),
              Positioned(
                top: 70,
                left: 45,
                child: _rankAvatar("assets/k.jpeg", "Hodges", "3080", 30),
              ),
              Positioned(
                top: 80,
                right: 45,
                child: _rankAvatar("assets/f.jpeg", "Charles", "2305", 30),
              ),
            ],
          ),
          // List container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                itemCount: userItems.length,
                itemBuilder: (context, index) {
                  final items = userItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(items["rank"],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 15),
                        CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(items["image"])),
                        const SizedBox(width: 15),
                        Text(items["name"],
                            style:
                                const TextStyle(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Container(
                          height: 25,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/co22.jpg',
                                  width: 18, height: 18),
                              const SizedBox(width: 5),
                              Text(items["point"].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankAvatar(String image, String name, String point, double radius) {
    return Column(
      children: [
        CircleAvatar(radius: radius, backgroundImage: AssetImage(image)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/co22.jpg', width: 18, height: 18),
              const SizedBox(width: 5),
              Text(point,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black)),
            ],
          ),
        ),
      ],
    );
  }
}
