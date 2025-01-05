import 'package:flutter/material.dart';
import 'utils/firebase_initializer.dart';
import 'pages/explore_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  // Uncomment the next line to load sample data (only do this once)
  // await FirebaseInitializer.loadSampleData();
  runApp(const AppStake());
}

class AppStake extends StatelessWidget {
  const AppStake({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppStake',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          // Using blue as primary color for a professional finance look
        ),
        useMaterial3: true,
        // Customize card theme for project cards
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Customize button theme for investment buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const ExplorePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
