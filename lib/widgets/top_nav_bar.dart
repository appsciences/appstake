import 'package:flutter/material.dart';
import '../pages/explore_page.dart';
import '../pages/how_it_works_page.dart';
import '../pages/create_project_page.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;

  const TopNavBar({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'appstake',
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.explore),
          label: const Text('Explore Projects'),
          onPressed: currentPage == 'explore' 
              ? null 
              : () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExplorePage(),
                  ),
                ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.rocket_launch),
          label: const Text('Start a Project'),
          onPressed: currentPage == 'start' 
              ? null 
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateProjectPage(),
                    ),
                  );
                },
        ),
        TextButton.icon(
          icon: const Icon(Icons.info_outline),
          label: const Text('How It Works'),
          onPressed: currentPage == 'how' 
              ? null 
              : () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HowItWorksPage(),
                  ),
                ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.help_outline),
          label: const Text('FAQ'),
          onPressed: currentPage == 'faq' 
              ? null 
              : () {
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