// lib/main.dart
import 'package:evidetask/presentation/pages/stop_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/bloc/stops/stops_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const StopSpotApp());
}

class StopSpotApp extends StatefulWidget {
  const StopSpotApp({super.key});

  @override
  State<StopSpotApp> createState() => _StopSpotAppState();
}

class _StopSpotAppState extends State<StopSpotApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StopSpot',
      debugShowCheckedModeBanner: false, // Removes debug banner
      themeMode: _themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) => di.sl<StopsBloc>(),
        child: StopsListPage(onThemeToggle: _toggleTheme),
      ),
    );
  }
}