import 'package:flutter/material.dart';
import 'screens/webview_screen.dart';

void main() {
  runApp(const SkyHikeApp());
}

class SkyHikeApp extends StatelessWidget {
  const SkyHikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyHike',
      home: const WebViewScreen(),
    );
  }
}