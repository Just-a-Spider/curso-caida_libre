import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/simulation_state.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CaidaLibreApp());
}

class CaidaLibreApp extends StatelessWidget {
  const CaidaLibreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SimulationState())],
      child: MaterialApp(
        title: 'GraviLab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
