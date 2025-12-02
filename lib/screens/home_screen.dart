import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/simulation_state.dart';
import 'simulation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _gravityController = TextEditingController();
  final TextEditingController _velocityController = TextEditingController();

  bool _airResistance = false;
  double _dragCoeff = 0.1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetValues();
    });
  }

  void _resetValues() {
    final state = context.read<SimulationState>();
    _heightController.text = state.initialHeight.toString();
    _gravityController.text = state.gravity.toString();
    _velocityController.text = state.initialVelocity.toString();
    setState(() {
      _airResistance = state.airResistanceEnabled;
      _dragCoeff = state.dragCoefficient;
    });
  }

  void _applySettings() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<SimulationState>();
      state.setParameters(
        height: double.tryParse(_heightController.text),
        gravity: double.tryParse(_gravityController.text),
        velocity: double.tryParse(_velocityController.text),
        airResistance: _airResistance,
        dragCoeff: _dragCoeff,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Datos actualizados!')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SimulationState>().reset();
              _resetValues();
            },
            tooltip: 'Reiniciar todo',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Desktop / Tablet Landscape Layout
            return Row(
              children: [
                SizedBox(width: 350, child: _buildControlPanel(context)),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const SimulationScreen(),
                  ),
                ),
              ],
            );
          } else {
            // Mobile / Portrait Layout
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const SimulationScreen(),
                  ),
                ),
                const Divider(height: 1),
                Expanded(flex: 2, child: _buildControlPanel(context)),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Configuración',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildNumberInput(
              controller: _heightController,
              label: 'Altura Inicial (m)',
              icon: Icons.height,
            ),
            const SizedBox(height: 12),
            _buildNumberInput(
              controller: _gravityController,
              label: 'Gravedad (m/s²)',
              icon: Icons.arrow_downward,
            ),
            const SizedBox(height: 12),
            _buildNumberInput(
              controller: _velocityController,
              label: 'Velocidad Inicial (m/s)',
              icon: Icons.speed,
              helperText: 'Positivo = hacia arriba (para ver zoom)',
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Resistencia del Aire'),
              value: _airResistance,
              onChanged: (bool value) {
                setState(() {
                  _airResistance = value;
                });
              },
              secondary: const Icon(FontAwesomeIcons.wind),
            ),
            if (_airResistance)
              Column(
                children: [
                  Text(
                    'Coeficiente de Arrastre: ${_dragCoeff.toStringAsFixed(2)}',
                  ),
                  Slider(
                    value: _dragCoeff,
                    min: 0.01,
                    max: 1.0,
                    divisions: 100,
                    label: _dragCoeff.toStringAsFixed(2),
                    onChanged: (double value) {
                      setState(() {
                        _dragCoeff = value;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _applySettings,
                    icon: const Icon(Icons.check),
                    label: const Text('Aplicar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Consumer<SimulationState>(
              builder: (context, state, _) {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isPlaying ? state.pause : state.play,
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(state.isPlaying ? 'Pausar' : 'Iniciar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.isPlaying
                              ? Colors.orange
                              : Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: state.reset,
                      icon: const Icon(Icons.replay),
                      tooltip: 'Reiniciar Simulación',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        helperText: helperText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese un valor';
        }
        if (double.tryParse(value) == null) {
          return 'Debe ser un número válido';
        }
        return null;
      },
    );
  }
}
