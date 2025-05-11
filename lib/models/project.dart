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
  final int projectedRevenue;
  final int projectionYears;

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
    required this.projectedRevenue,
    required this.projectionYears,
  });

  double get progressPercentage => (raisedAmount / targetAmount * 100).clamp(0, 100);

  factory Project.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Safely handle Timestamp conversion
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }
      return DateTime.now(); // Fallback to current time if invalid
    }

    return Project(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      raisedAmount: (data['raisedAmount'] ?? 0).toDouble(),
      status: data['status']?.toString() ?? 'upcoming',
      createdAt: parseTimestamp(data['createdAt']),
      deadline: parseTimestamp(data['deadline']),
      investorCount: (data['investorCount'] ?? 0) as int,
      minInvestment: (data['minInvestment'] ?? 100) as int,
      projectedRevenue: (data['projectedRevenue'] ?? 0) as int,
      projectionYears: (data['projectionYears'] ?? 0) as int,
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
      'projectedRevenue': projectedRevenue,
      'projectionYears': projectionYears,
    };
  }
} 