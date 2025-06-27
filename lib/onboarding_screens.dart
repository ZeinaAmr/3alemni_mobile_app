import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/onboarding1.jpg',
      'title': 'Your Personalized Learning Hub',
      'desc':
      'Find nearby centers and top teachers, enroll in courses, and stay on track with your calendar. Use our AI tools to turn notes into study reels, summaries, and quiz questions.',
    },
    {
      'image': 'assets/onboarding2.jpg',
      'title': 'Teach and Inspire with Ease',
      'desc':
      'Create courses, upload materials, and teach online. Need help? Post jobs and find qualified assistants right from the app.',
    },
    {
      'image': 'assets/onboarding3.jpg',
      'title': 'Start Your Educational Career',
      'desc':
      'Explore teaching assistant jobs, apply with a tap, and gain experience supporting educators and students.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacementNamed(context, '/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(page['image']!, fit: BoxFit.contain),
                ),
                const SizedBox(height: 20),
                Text(
                  page['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  page['desc']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (i) => AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 12 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Color(0xFFFF7C34) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF7C34),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                    child: const Text("Register Now", style: TextStyle(fontSize: 16)),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text("Skip",style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: _nextPage,
                        child: const Text("Next",style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
