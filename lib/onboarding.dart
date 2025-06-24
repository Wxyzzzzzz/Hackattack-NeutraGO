import 'package:flutter/material.dart';
import 'main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Track Your Carbon Footprint',
      description:
          'Effortlessly monitor your daily CO₂ emissions based on your travel habits.',
      imageUrl: 'https://cdn.builder.io/api/v1/image/assets%2Fexample1.webp',
    ),
    _OnboardingPageData(
      title: 'Automatic Trip Detection ',
      description:
          'Our smart system detects your travel mode—walk, car, train, and more without any manual input.',
      imageUrl: 'https://cdn.builder.io/api/v1/image/assets%2Fexample2.webp',
    ),
    _OnboardingPageData(
      title: 'Smart Trip Planning, Made Easy',
      description:
          'Plan your journey with ease.  Neutra GO suggests the best route tailored to your lifestyle.',
      imageUrl: 'https://cdn.builder.io/api/v1/image/assets%2Fexample3.webp',
    ),
    _OnboardingPageData(
      title: 'Rewards for Greener Choices',
      description:
          'Earn badges, climb local leaderboards, and unlock real-world rewards by going green!',
      imageUrl: 'https://cdn.builder.io/api/v1/image/assets%2Fexample4.webp',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skipTour() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2E4),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 44),
                      // App Title
                      const Text(
                        'Neutra GO',
                        style: TextStyle(
                          color: Color(0xFF102B23),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Image
                      SizedBox(
                        height: 250,
                        child: Image.network(
                          page.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.eco,
                                  size: 120, color: Color(0xFF7A9B5A)),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Title
                      Text(
                        page.title,
                        style: const TextStyle(
                          color: Color(0xFF102B23),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Description
                      Text(
                        page.description,
                        style: const TextStyle(
                          color: Color(0xFF3F816C),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _currentPage
                                  ? const Color(0xFFFFAF44)
                                  : const Color(0xFFFDE18B),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
            // Skip Tour Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 80,
              child: GestureDetector(
                onTap: _skipTour,
                child: Center(
                  child: Text(
                    'Skip Tour',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final String imageUrl;

  _OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
