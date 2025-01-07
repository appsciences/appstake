import 'package:flutter/material.dart';
import '../services/project_service.dart';
import '../models/project.dart';
import '../widgets/top_nav_bar.dart';
import '../layouts/responsive_layout.dart';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  final ProjectService _projectService = ProjectService();

  ProjectDetailPage({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      drawer: const SizedBox(),
      body: Scaffold(
        appBar: const TopNavBar(),
        body: FutureBuilder<Project?>(
          future: _projectService.getProject(projectId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Project not found'));
            }

            final project = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with project image
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Image.network(
                      project.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Project details
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                project.description,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Investment Highlights',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildHighlight(
                                context,
                                icon: Icons.trending_up,
                                title: 'Market Opportunity',
                                description: 'Targeting a growing market with significant potential.',
                              ),
                              _buildHighlight(
                                context,
                                icon: Icons.lightbulb_outline,
                                title: 'Innovation',
                                description: 'Unique solution with competitive advantages.',
                              ),
                              _buildHighlight(
                                context,
                                icon: Icons.groups,
                                title: 'Strong Team',
                                description: 'Experienced leadership with proven track record.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                        // Right side - Investment card
                        Expanded(
                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${project.raisedAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'raised of \$${project.targetAmount.toStringAsFixed(0)} goal',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  LinearProgressIndicator(
                                    value: project.progressPercentage / 100,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildInvestmentStat('Progress', '${project.progressPercentage.toStringAsFixed(0)}%'),
                                  _buildInvestmentStat('Minimum Investment', '\$100'),
                                  _buildInvestmentStat('Share Price', '\$10'),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement investment flow
                                      },
                                      child: const Text(
                                        'Invest Now',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Text(
                                      'Offering closes in ${_getDaysRemaining(project.deadline)} days',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHighlight(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  int _getDaysRemaining(DateTime deadline) {
    return deadline.difference(DateTime.now()).inDays;
  }
} 