import 'package:flutter/material.dart';
import 'screens/main_menu.dart';
import 'services/word_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WordService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kroat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.blue[100],
      ),
      home: const MainMenu(),
    );
  }
}
