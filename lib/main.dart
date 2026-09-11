import 'package:flutter/material.dart';
import 'screens/webview_screen.dart';

void main() {
  runApp(const PearlMarketplaceApp());
}

class PearlMarketplaceApp extends StatelessWidget {
  const PearlMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PearlMarketplace',
      home: const WebViewScreen(),
    );
  }
}