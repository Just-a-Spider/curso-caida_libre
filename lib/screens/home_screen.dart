import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/simulation_state.dart';
import 'simulation_view.dart';
import 'challenge_screen.dart'; // Still named challenge_screen.dart file, but class is ChallengeView

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _switchToSimulation() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _views = [
      const SimulationView(),
      ChallengeView(onLoadSimulation: _switchToSimulation),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(FontAwesomeIcons.feather, size: 20),
            SizedBox(width: 10),
            Text('Simulador de Caída Libre'),
          ],
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<SimulationState>().reset();
                // We need a way to reset values in SimulationView.
                // Ideally SimulationView listens to state changes or we trigger it.
                // For now, the state reset is enough, SimulationView will rebuild.
              },
              tooltip: 'Reiniciar Simulación',
            ),
        ],
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science),
            label: 'Simulador',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.graduationCap),
            selectedIcon: Icon(
              FontAwesomeIcons.graduationCap,
              color: Colors.blue,
            ),
            label: 'Desafíos',
          ),
        ],
      ),
    );
  }
}
