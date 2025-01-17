import 'package:flutter/material.dart';
import '../pages/explore_page.dart';
import '../pages/how_it_works_page.dart';
import '../pages/front_page.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {

  const TopNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const FrontPage(),
                ),
              ),
        child: const Text(
          'appstake',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.explore),
          label: const Text('Explore Projects'),
          onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExplorePage(),
                  ),
                ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.rocket_launch),
          label: const Text('Start a Project'),
          onPressed:  () {
                  // TODO: Navigate to start project
                },
        ),
        TextButton.icon(
          icon: const Icon(Icons.info_outline),
          label: const Text('How It Works'),
          onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HowItWorksPage(),
                  ),
                ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.help_outline),
          label: const Text('FAQ'),
          onPressed:  () {
                  // TODO: Navigate to FAQ
                },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // TODO: Implement search
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            // TODO: Implement sign in
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 