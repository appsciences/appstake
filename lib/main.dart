import 'package:flutter/material.dart';
import 'utils/firebase_initializer.dart';
import 'pages/explore_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  // Uncomment to reset database with fresh sample data
  await FirebaseInitializer.blowProjectData();
  await FirebaseInitializer.writeProjectSampleData();
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
          seedColor: const Color.fromARGB(255, 33, 243, 75),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Color.fromARGB(255, 247, 248, 245),
        ),
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
