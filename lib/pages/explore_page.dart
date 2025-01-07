import 'package:flutter/material.dart';
import 'project_detail_page.dart';
import '../layouts/responsive_layout.dart';
import 'how_it_works_page.dart';
import 'my_investments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../services/project_service.dart';
import '../widgets/top_nav_bar.dart';

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
        appBar: const TopNavBar(currentPage: 'explore'),
        body: Column(
          children: [
            // Filter section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        // Remove dropdown underline
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        underline: Container(), // Remove underline
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Categories')),
                          DropdownMenuItem(value: 'ai', child: Text('AI & Machine Learning')),
                          DropdownMenuItem(value: 'social', child: Text('Social Networking')),
                          DropdownMenuItem(value: 'fintech', child: Text('FinTech')),
                          DropdownMenuItem(value: 'health', child: Text('Health & Fitness')),
                          DropdownMenuItem(value: 'ecommerce', child: Text('E-commerce')),
                          DropdownMenuItem(value: 'education', child: Text('Education')),
                          DropdownMenuItem(value: 'gaming', child: Text('Gaming')),
                          DropdownMenuItem(value: 'productivity', child: Text('Productivity')),
                          DropdownMenuItem(value: 'travel', child: Text('Travel & Local')),
                          DropdownMenuItem(value: 'entertainment', child: Text('Entertainment')),
                          DropdownMenuItem(value: 'food', child: Text('Food & Drink')),
                          DropdownMenuItem(value: 'lifestyle', child: Text('Lifestyle')),
                          DropdownMenuItem(value: 'dating', child: Text('Dating')),
                          DropdownMenuItem(value: 'crypto', child: Text('Crypto & Web3')),
                          DropdownMenuItem(value: 'iot', child: Text('IoT & Smart Home')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                        // Add padding to dropdown items
                        itemHeight: 48,
                        dropdownColor: Theme.of(context).cardColor,
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedSort,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Sort by',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.keyboard_arrow_down),
                        ),
                        underline: Container(),
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
                        itemHeight: 48,
                        dropdownColor: Theme.of(context).cardColor,
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Project sections
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                children: [
                  _buildProjectSection(
                    title: 'Newly Launched',
                    stream: _projectService.getProjects(sortBy: 'newest', limit: 3),
                  ),
                  _buildProjectSection(
                    title: 'Most Active',
                    stream: _projectService.getProjects(sortBy: 'active', limit: 3),
                  ),
                  _buildProjectSection(
                    title: 'Most Funded',
                    stream: _projectService.getProjects(sortBy: 'mostFunded', limit: 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSection({
    required String title,
    required Stream<List<Project>> stream,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 400, // Adjust based on your card size
          child: StreamBuilder<List<Project>>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final projects = snapshot.data ?? [];

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: SizedBox(
                      width: 306, // Changed from 360 to 306 (15% smaller)
                      child: ProjectCard(project: projects[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  image: DecorationImage(
                    image: NetworkImage(project.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('\$${(project.raisedAmount/1000000).toStringAsFixed(1)}M', 'Raised'),
                      _buildStat('${project.investorCount}', 'Investors'),
                      _buildStat('\$${project.minInvestment}', 'Min. Investment'),
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

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1B4B66), // Dark teal color
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 