import 'package:cloud_firestore/cloud_firestore.dart';

class SampleDataGenerator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> clearProjectData() async {
    final snapshots = await _firestore.collection('projects').get();
    final batch = _firestore.batch();
    
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  Future<void> generateProjectData() async {
    final List<Map<String, dynamic>> sampleProjects = [
      {
        'name': 'FitTrack Pro',
        'description': 'AI-powered fitness tracking app with personalized workout plans and nutrition guidance.',
        'imageUrl': 'https://picsum.photos/seed/fit/800/600',
        'targetAmount': 500000,
        'raisedAmount': 325000,
        'status': 'active',
        'createdAt': Timestamp.now(),
        'deadline': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 45)),
        ),
        'investorCount': 150,
      },
      {
        'name': 'EcoMarket',
        'description': 'Sustainable shopping platform connecting eco-conscious consumers with verified green vendors.',
        'imageUrl': 'https://picsum.photos/seed/eco/800/600',
        'targetAmount': 750000,
        'raisedAmount': 180000,
        'status': 'active',
        'createdAt': Timestamp.now(),
        'deadline': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 60)),
        ),
        'investorCount': 220,
      },
      {
        'name': 'KidsLearn AI',
        'description': 'Educational app using AI to adapt to each child\'s learning style and pace.',
        'imageUrl': 'https://picsum.photos/seed/kids/800/600',
        'targetAmount': 1000000,
        'raisedAmount': 850000,
        'status': 'active',
        'createdAt': Timestamp.now(),
        'deadline': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
        'investorCount': 180,
      },
      {
        'name': 'CryptoWallet Pro',
        'description': 'Secure and user-friendly cryptocurrency wallet with built-in exchange.',
        'imageUrl': 'https://picsum.photos/seed/crypto/800/600',
        'targetAmount': 2000000,
        'raisedAmount': 2000000,
        'status': 'funded',
        'createdAt': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 90)),
        ),
        'deadline': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 30)),
        ),
        'investorCount': 617,
      },
      {
        'name': 'SocialChef',
        'description': 'Social network for chefs and food enthusiasts with recipe sharing and cooking challenges.',
        'imageUrl': 'https://picsum.photos/seed/chef/800/600',
        'targetAmount': 300000,
        'raisedAmount': 0,
        'status': 'upcoming',
        'createdAt': Timestamp.now(),
        'deadline': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 90)),
        ),
        'investorCount': 0,
      },
    ];

    // Add sample projects to Firestore
    final batch = _firestore.batch();
    
    for (final project in sampleProjects) {
      final docRef = _firestore.collection('projects').doc();
      batch.set(docRef, project);
    }

    await batch.commit();
  }
} 