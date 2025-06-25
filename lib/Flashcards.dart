// === FLASHCARDS.DART ===
import 'package:flutter/material.dart';
import 'dart:math';
import 'SideBar.dart';

class FlashcardsScreen extends StatefulWidget {
  final String userId;
  FlashcardsScreen({required this.userId});

  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(userId: widget.userId),
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Flashcards",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF187E8A)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final angle = _animation.value * pi;
              final isBack = angle > pi / 2;

              return Transform(
                transform: Matrix4.rotationY(angle),
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    if (isBack)
                      Transform(
                        transform: Matrix4.rotationY(pi),
                        alignment: Alignment.center,
                        child: _buildCard(
                          text: 'Question: What is the capital of France?',
                          color: const Color(0xFFD85E09),
                        ),
                      ),
                    if (!isBack)
                      _buildCard(
                        text: 'Answer: Paris',
                        color: const Color(0xFF13A7B1),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String text, required Color color}) {
    return Container(
      width: 400,
      height: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
