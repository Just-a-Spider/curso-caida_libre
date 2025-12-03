import 'dart:math';

enum ChallengeType { findTime, findVelocity, findHeight }

class Challenge {
  final ChallengeType type;
  final double height;
  final double gravity;
  final double initialVelocity; // Positive = down, Negative = up
  final double correctAnswer;
  final String questionText;
  final String explanation;

  Challenge({
    required this.type,
    required this.height,
    required this.gravity,
    required this.initialVelocity,
    required this.correctAnswer,
    required this.questionText,
    required this.explanation,
  });

  static Challenge generateRandom() {
    final random = Random();
    final type =
        ChallengeType.values[random.nextInt(ChallengeType.values.length)];

    // Randomize parameters
    // Height: 20m to 200m
    double h = (random.nextInt(180) + 20).toDouble();

    // Gravity: Earth (9.81) mostly, sometimes Moon (1.62) or Mars (3.72)
    double g = 9.81;
    int gRoll = random.nextInt(10);
    if (gRoll == 8) g = 1.62; // Moon
    if (gRoll == 9) g = 3.72; // Mars

    // Initial Velocity: -20 to 20 m/s
    double v0 = (random.nextInt(41) - 20).toDouble();

    // Ensure we don't start underground or with impossible conditions
    // If v0 is negative (up), make sure h is high enough or just keep it simple

    String question = "";
    double answer = 0;
    String explain = "";

    switch (type) {
      case ChallengeType.findTime:
        // Question: How long until it hits the ground?
        // 0 = h + v0*t - 0.5*g*t^2  => 0.5*g*t^2 - v0*t - h = 0
        // t = (v0 + sqrt(v0^2 + 2*g*h)) / g  (taking positive root)
        double discriminant = v0 * v0 + 2 * g * h;
        answer = (v0 + sqrt(discriminant)) / g;

        question =
            "Un objeto se lanza desde una altura de ${h.toStringAsFixed(1)} m con una velocidad inicial de ${v0.toStringAsFixed(1)} m/s (positivo=abajo). Considerando g = ${g.toStringAsFixed(2)} m/s², ¿cuánto tiempo tarda en llegar al suelo?";
        explain =
            "Usa la fórmula: y = y0 + v0*t - 0.5*g*t^2. Al llegar al suelo, y=0. Resuelve la ecuación cuadrática para t.";
        break;

      case ChallengeType.findVelocity:
        // Question: What is the velocity when it hits the ground?
        // v^2 = v0^2 + 2*g*h (Torricelli) -> v = sqrt(v0^2 + 2*g*h)
        // Note: v is directed downwards, so positive in our model?
        // Wait, our model uses v = v0 - g*t? No, v = v0 + g*t if g is acceleration downwards and we track speed?
        // Let's check SimulationState logic:
        // v = v0 - g*t (where g is positive 9.81). So gravity reduces upward velocity (negative v0) or increases downward velocity?
        // Wait, in SimulationState: v = initialVelocity - (gravity * time).
        // If v0=0, v becomes negative. So DOWN is NEGATIVE velocity in SimulationState?
        // Let's re-read SimulationState.
        // h = initialHeight + (initialVelocity * time) - (0.5 * gravity * time * time);
        // If v0=0, h decreases. Correct.
        // v = initialVelocity - (gravity * time).
        // If v0=0, v becomes negative. So DOWN is NEGATIVE.
        // BUT in HomeScreen I wrote: "Positivo = hacia arriba".
        // Let's check HomeScreen helper text: "Positivo = hacia arriba (para ver zoom)".
        // Wait, in the previous turn I wrote: "Positivo = hacia arriba (para ver zoom)" in HomeScreen.
        // Let's check SimulationState again.
        // h = y0 + v0*t - 0.5*g*t^2.
        // If v0 is positive, h INCREASES initially. So Positive v0 = UP.
        // Gravity is subtracted, so it accelerates DOWN.
        // So UP is POSITIVE. DOWN is NEGATIVE.

        // So for the problem:
        // If we say "velocidad inicial de X", we need to specify direction.
        // Let's assume the question uses standard physics convention: Up is +y.

        // Calculate impact velocity
        double discriminantV =
            v0 * v0 +
            2 *
                g *
                h; // v^2 = v0^2 - 2*g*(y - y0). y=0, y0=h. v^2 = v0^2 - 2*g*(-h) = v0^2 + 2gh.
        double impactSpeed = sqrt(discriminantV);
        answer = -impactSpeed; // Velocity is downwards upon impact

        question =
            "Un objeto se lanza desde ${h.toStringAsFixed(1)} m con velocidad inicial ${v0.toStringAsFixed(1)} m/s (positivo=arriba). Con g = ${g.toStringAsFixed(2)} m/s², ¿cuál es su velocidad al impactar el suelo? (Indica el signo)";
        explain =
            "Usa la conservación de energía o la fórmula v^2 = v0^2 - 2g(y-y0). Recuerda que al caer, la velocidad es negativa (hacia abajo).";
        break;

      case ChallengeType.findHeight:
        // Question: If it falls for t seconds and hits the ground, what was the initial height? (Assuming v0 known)
        // Or: It hits the ground with velocity v. What was h?
        // Let's go with: It takes t seconds to hit the ground from rest (v0=0). What is h?
        v0 = 0; // Simplify for this type
        double t = (random.nextInt(50) + 10) / 10.0; // 1.0 to 6.0 seconds
        answer = 0.5 * g * t * t;
        h = answer; // Set the scenario to match

        question =
            "Un objeto se deja caer (v0=0) y tarda ${t.toStringAsFixed(1)} s en llegar al suelo. Con g = ${g.toStringAsFixed(2)} m/s², ¿desde qué altura cayó?";
        explain =
            "Usa y = y0 + v0*t - 0.5*g*t^2. Sabemos y=0, v0=0. Despeja y0.";
        break;
    }

    return Challenge(
      type: type,
      height: h,
      gravity: g,
      initialVelocity: v0,
      correctAnswer: answer,
      questionText: question,
      explanation: explain,
    );
  }
}
