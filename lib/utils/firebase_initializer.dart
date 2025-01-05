import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'sample_data.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> loadSampleData() async {
    final generator = SampleDataGenerator();
    await generator.generateSampleData();
  }
} 