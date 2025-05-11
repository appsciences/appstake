import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  ProjectService() {
    // Enable offline persistence
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Stream<List<Project>> getProjects({
    String? status,
    String? sortBy,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection('projects');
      
      switch (sortBy) {
        case 'newest':
          query = query.orderBy('createdAt', descending: true);
          break;
        case 'mostFunded':
          query = query.orderBy('raisedAmount', descending: true);
          break;
        case 'active':
          query = query.orderBy('investorCount', descending: true);
          break;
        default:
          query = query.orderBy('createdAt', descending: true);
      }

      if (status != null && status != 'all' && sortBy != 'active') {
        query = query.where('status', isEqualTo: status);
      }

      if (limit != null) {
        query = query.limit(limit);
      }
      
      return query
          .withConverter(
            fromFirestore: (snapshot, _) => Project.fromFirestore(snapshot),
            toFirestore: (Project project, _) => project.toFirestore(),
          )
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      // Return an empty list stream in case of error
      return Stream.value([]);
    }
  }

  Future<Project?> getProject(String id) async {
    try {
      // Try cache first
      final doc = await _firestore
          .collection('projects')
          .doc(id)
          .withConverter(
            fromFirestore: (snapshot, _) => Project.fromFirestore(snapshot),
            toFirestore: (Project project, _) => project.toFirestore(),
          )
          .get(const GetOptions(source: Source.cache));
      
      if (doc.exists) {
        return doc.data();
      }
      
      // If not in cache, try server
      final serverDoc = await _firestore
          .collection('projects')
          .doc(id)
          .withConverter(
            fromFirestore: (snapshot, _) => Project.fromFirestore(snapshot),
            toFirestore: (Project project, _) => project.toFirestore(),
          )
          .get();
          
      return serverDoc.data();
    } catch (e) {
      print('Error fetching project: $e');
      return null;
    }
  }
} 