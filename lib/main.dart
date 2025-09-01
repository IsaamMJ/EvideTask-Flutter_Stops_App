// lib/main.dart
import 'package:evidetask/presentation/bloc/stops/stops_bloc.dart';
import 'package:evidetask/presentation/pages/stop_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stops App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => di.sl<StopsBloc>(),
        child: const StopsListPage(),
      ),
    );
  }
}