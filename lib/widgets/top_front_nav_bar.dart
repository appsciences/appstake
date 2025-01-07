import 'package:flutter/material.dart';
import '../pages/explore_page.dart';
import '../pages/how_it_works_page.dart';
import '../pages/front_page.dart';

class TopFrontNavBar extends StatelessWidget implements PreferredSizeWidget {

  const TopFrontNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap:  
             () => Navigator.pushReplacement(
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
          icon: const Icon(Icons.lightbulb_outline),
          label: const Text('Why appstake'),
          onPressed: 
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExplorePage(),
                  ),
                ),
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
        
         TextButton.icon(
          icon: const Icon(Icons.person_outline),
          label: const Text('Sign In'),
          onPressed:  () {
                  // TODO: Navigate to Sign IN
                },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 