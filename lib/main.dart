import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/navigation/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LyraXApp());
}

class LyraXApp extends StatelessWidget {
  const LyraXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LyraX — AI Creator Royalty Financing on Stellar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainShell(),
    );
  }
}
