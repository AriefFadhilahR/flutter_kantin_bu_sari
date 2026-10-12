import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'theme.dart';

void main() => runApp(const KantinBuSariApp());

class KantinBuSariApp extends StatelessWidget {
  const KantinBuSariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashPage(),
    );
  }
}
