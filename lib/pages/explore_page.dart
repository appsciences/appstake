import 'package:flutter/material.dart';
import 'project_detail_page.dart';
import '../layouts/responsive_layout.dart';
import 'how_it_works_page.dart';
import 'my_investments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../services/project_service.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ProjectService _projectService = ProjectService();
  String? _selectedStatus;
  String? _selectedSort;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      drawer: const SizedBox(),
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Discover App Projects'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.explore),
              tooltip: 'Navigation Menu',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'explore',
                  child: Row(
                    children: [
                      Icon(Icons.explore),
                      SizedBox(width: 8),
                      Text('Explore Projects'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'investments',
                  child: Row(
                    children: [
                      Icon(Icons.account_balance_wallet),
                      SizedBox(width: 8),
                      Text('My Investments'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'start',
                  child: Row(
                    children: [
                      Icon(Icons.rocket_launch),
                      SizedBox(width: 8),
                      Text('Start a Project'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'how',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Text('How It Works'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'faq',
                  child: Row(
                    children: [
                      Icon(Icons.help_outline),
                      SizedBox(width: 8),
                      Text('FAQ'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'support',
                  child: Row(
                    children: [
                      Icon(Icons.contact_support_outlined),
                      SizedBox(width: 8),
                      Text('Support'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'investments':
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const MyInvestmentsPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;
                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                    break;
                  // Add other navigation cases here
                }
              },
            ),
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
        ),
        body: Column(
          children: [
            // Filter section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedStatus,
                    hint: const Text('Filter by Status'),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Projects')),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(value: 'funded', child: Text('Funded')),
                      DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedSort,
                    hint: const Text('Sort by'),
                    items: const [
                      DropdownMenuItem(value: 'trending', child: Text('Trending')),
                      DropdownMenuItem(value: 'newest', child: Text('Newest')),
                      DropdownMenuItem(value: 'mostFunded', child: Text('Most Funded')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            
            // Project grid
            Expanded(
              child: StreamBuilder<List<Project>>(
                stream: _projectService.getProjects(
                  status: _selectedStatus,
                  sortBy: _selectedSort,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final projects = snapshot.data ?? [];

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      right: 24.0,
                      bottom: 24.0,
                      left: 24.0,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemBuilder: (context, index) => ProjectCard(
                      project: projects[index],
                    ),
                    itemCount: projects.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailPage(projectId: project.id),
            ),
            
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  image: DecorationImage(
                    image: NetworkImage(project.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * 1.10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${project.projectedRevenue}K/${project.projectionYears} yr',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Tooltip(
                        message: 'AI projected ${project.projectionYears} year revenue',
                        child: Icon(
                          Icons.help_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize! * 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: project.progressPercentage / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${project.raisedAmount.toStringAsFixed(0)} raised',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.25,
                        ),
                      ),
                      Text(
                        '${project.progressPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 