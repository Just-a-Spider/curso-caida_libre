import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/challenge_model.dart';
import '../models/simulation_state.dart';

class ChallengeView extends StatefulWidget {
  final VoidCallback onLoadSimulation;

  const ChallengeView({super.key, required this.onLoadSimulation});

  @override
  State<ChallengeView> createState() => _ChallengeViewState();
}

class _ChallengeViewState extends State<ChallengeView> {
  Challenge? _currentChallenge;
  final TextEditingController _answerController = TextEditingController();
  bool _showFeedback = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateNewChallenge();
  }

  void _generateNewChallenge() {
    setState(() {
      _currentChallenge = Challenge.generateRandom();
      _answerController.clear();
      _showFeedback = false;
    });
  }

  void _checkAnswer() {
    if (_currentChallenge == null || _answerController.text.isEmpty) return;

    double? userAnswer = double.tryParse(_answerController.text);
    if (userAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un número válido')),
      );
      return;
    }

    // Allow 5% margin of error
    double errorMargin = _currentChallenge!.correctAnswer.abs() * 0.05;
    // If answer is 0, use fixed margin
    if (errorMargin == 0) errorMargin = 0.1;

    bool correct =
        (userAnswer - _currentChallenge!.correctAnswer).abs() <= errorMargin;

    setState(() {
      _isCorrect = correct;
      _showFeedback = true;
    });
  }

  void _loadToSimulation() {
    if (_currentChallenge == null) return;

    final state = context.read<SimulationState>();
    state.setParameters(
      height: _currentChallenge!.height,
      gravity: _currentChallenge!.gravity,
      velocity: _currentChallenge!.initialVelocity,
      airResistance: false, // Challenges assume vacuum for simplicity usually
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Datos cargados en el simulador!')),
    );

    // Call callback to switch tab
    widget.onLoadSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Header since we removed AppBar
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Modo Desafío',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _generateNewChallenge,
                tooltip: 'Nuevo Problema',
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _currentChallenge == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.graduationCap,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Problema de Física',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 10),
                              Text(
                                _currentChallenge!.questionText,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _answerController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Tu Respuesta',
                          border: OutlineInputBorder(),
                          helperText: 'Usa punto para decimales',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _checkAnswer,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Verificar Respuesta'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_showFeedback)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isCorrect
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isCorrect ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _isCorrect ? Icons.check : Icons.close,
                                    color: _isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _isCorrect ? '¡Correcto!' : 'Incorrecto',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _isCorrect
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Respuesta correcta: ${_currentChallenge!.correctAnswer.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(_currentChallenge!.explanation),
                              const SizedBox(height: 15),
                              OutlinedButton.icon(
                                onPressed: _loadToSimulation,
                                icon: const Icon(Icons.science),
                                label: const Text('Ver en Simulador'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
