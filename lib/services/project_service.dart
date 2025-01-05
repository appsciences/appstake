import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<List<Project>> getProjects({
    String? status,
    String? sortBy,
  }) {
    Query query = _firestore.collection('projects');
    
    if (status != null && status != 'all') {
      query = query.where('status', isEqualTo: status);
    }
    
    switch (sortBy) {
      case 'newest':
        query = query.orderBy('createdAt', descending: true);
        break;
      case 'mostFunded':
        query = query.orderBy('raisedAmount', descending: true);
        break;
      case 'trending':
        // You might want to implement a more sophisticated trending algorithm
        query = query.orderBy('raisedAmount', descending: true)
                    .orderBy('createdAt', descending: true);
        break;
      default:
        query = query.orderBy('createdAt', descending: true);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();
    });
  }

  Future<Project?> getProject(String id) async {
    final doc = await _firestore.collection('projects').doc(id).get();
    if (doc.exists) {
      return Project.fromFirestore(doc);
    }
    return null;
  }
} 