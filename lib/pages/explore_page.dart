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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'AppStake',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invest in the future of mobile apps',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Explore Projects'),
              selected: true,
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('My Investments'),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.rocket_launch),
              title: const Text('Start a Project'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to project creation
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('How It Works'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to how it works page
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to FAQ page
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support_outlined),
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to support page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to sign in page
              },
            ),
          ],
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Discover App Projects'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search
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
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: project.progressPercentage / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${project.raisedAmount.toStringAsFixed(0)} raised'),
                      Text('${project.progressPercentage.toStringAsFixed(0)}%'),
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