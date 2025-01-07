import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double targetAmount;
  final double raisedAmount;
  final String status; // 'active', 'funded', 'upcoming'
  final DateTime createdAt;
  final DateTime deadline;
  final int investorCount;
  final int minInvestment;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.targetAmount,
    required this.raisedAmount,
    required this.status,
    required this.createdAt,
    required this.deadline,
    required this.investorCount,
    required this.minInvestment,
  });

  double get progressPercentage => (raisedAmount / targetAmount * 100).clamp(0, 100);

  factory Project.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Project(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      raisedAmount: (data['raisedAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'upcoming',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      investorCount: data['investorCount'] ?? 0,
      minInvestment: data['minInvestment'] ?? 100,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'targetAmount': targetAmount,
      'raisedAmount': raisedAmount,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'deadline': Timestamp.fromDate(deadline),
      'investorCount': investorCount,
      'minInvestment': minInvestment,
    };
  }
} 