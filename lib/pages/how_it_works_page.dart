import 'package:flutter/material.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How It Works'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildStep(
            context,
            icon: Icons.search,
            title: 'Discover',
            description: 'Browse through innovative mobile app projects.',
          ),
          _buildStep(
            context,
            icon: Icons.analytics,
            title: 'Research',
            description: 'Review project details, team, and financials.',
          ),
          _buildStep(
            context,
            icon: Icons.payments,
            title: 'Invest',
            description: 'Choose your investment amount and complete the transaction.',
          ),
          _buildStep(
            context,
            icon: Icons.trending_up,
            title: 'Track',
            description: 'Monitor your investment and project progress.',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 