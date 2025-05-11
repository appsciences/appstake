import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/project_service.dart';
import '../models/project.dart';
import '../widgets/top_nav_bar.dart';
import 'edit_project_page.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  final ProjectService _projectService = ProjectService();

  ProjectDetailPage({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return CustomScrollView(
            slivers: [
              // Header with project image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final updatedProject = await Navigator.push<Project>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProjectPage(project: project),
                        ),
                      );
                      if (updatedProject != null) {
                        // Refresh the page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailPage(
                              projectId: updatedProject.id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    project.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onDoubleTap: () async {
                                  final updatedProject = await Navigator.push<Project>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProjectPage(project: project),
                                    ),
                                  );
                                  if (updatedProject != null) {
                                    // Refresh the page
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectDetailPage(
                                          projectId: updatedProject.id,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  project.name,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
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
                        SizedBox(
                          width: 350,
                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${NumberFormat('#,###').format(project.raisedAmount)}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'raised of \$${NumberFormat('#,###').format(project.targetAmount)} goal',
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
                                  _buildInvestmentStat('Minimum Investment', '\$100 (\$APST 1,365,220)'),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement investment flow
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Get your shiny ',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Image.asset(
                                            'assets/images/nft.png',
                                            height: 24,
                                            width: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Text(
                                      'Offering closes in ${_getDaysRemaining(project.deadline)} days',
                                      style: const TextStyle(color: Colors.red),
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
                ),
              ),
            ],
          );
        },
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