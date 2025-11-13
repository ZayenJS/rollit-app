import 'package:rollit/screens/home.screen.dart';
import 'package:rollit/screens/settings.screen.dart';
import 'package:rollit/services/ads.service.dart';
import 'package:rollit/services/purchase.service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PurchaseService.instance.init();
  await AdsService.instance.init();

  runApp(const RollitApp());
}

class RollitApp extends StatelessWidget {
  const RollitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rollit!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF7F8FF),
        useMaterial3: true,
      ),
      routes: {'/settings': (_) => const SettingsScreen()},
      home: const HomeScreen(),
    );
  }
}
