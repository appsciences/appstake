import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import 'sample_data.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

static Future<void> blowProjectData() async {
    final generator = SampleDataGenerator();
    await generator.clearProjectData();
  }
 
  static Future<void> writeProjectSampleData() async {
    final generator = SampleDataGenerator();
    await generator.generateProjectData();
  }
} 