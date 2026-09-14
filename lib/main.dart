import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/bookmark_service.dart';
import 'core/services/network_service.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize core services
  await NetworkService().initialize();
  await BookmarkService().initialize();

  runApp(const PearlMarketplaceApp());
}

class PearlMarketplaceApp extends StatelessWidget {
  const PearlMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pearl Marketplace',
      theme: AppTheme.lightTheme,
      home: const MainShellScreen(),
    );
  }
}