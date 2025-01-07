import 'package:flutter/material.dart';
import '../widgets/top_front_nav_bar.dart';
import '../layouts/responsive_layout.dart';
import '../widgets/tech_flow_background.dart';
import 'explore_page.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      drawer: const SizedBox(),
      body: Scaffold(
        appBar: const TopFrontNavBar(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Animated background
            const TechFlowBackground(),
            // Dark overlay
            Container(
              color: Colors.black.withOpacity(0.4),
            ),
            // Centered button
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExplorePage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.rocket_launch, color: Colors.white),
                label: const Text(
                  'Launch App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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