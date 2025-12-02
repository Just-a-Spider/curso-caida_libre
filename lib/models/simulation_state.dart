import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SimulationState extends ChangeNotifier {
  // Simulation Parameters
  double _initialHeight = 100.0; // meters
  double _gravity = 9.81; // m/s^2
  double _initialVelocity = 0.0; // m/s
  double _mass = 1.0; // kg
  bool _airResistanceEnabled = false;
  double _dragCoefficient = 0.1; // Simple drag factor k

  // Runtime State
  double _currentTime = 0.0; // seconds
  double _currentHeight = 100.0;
  double _currentVelocity = 0.0;
  double _maxHeightReached = 100.0;

  bool _isPlaying = false;
  Timer? _timer;

  // Getters
  double get initialHeight => _initialHeight;
  double get gravity => _gravity;
  double get initialVelocity => _initialVelocity;
  double get mass => _mass;
  bool get airResistanceEnabled => _airResistanceEnabled;
  double get dragCoefficient => _dragCoefficient;

  double get currentTime => _currentTime;
  double get currentHeight => _currentHeight;
  double get currentVelocity => _currentVelocity;
  double get maxHeightReached => _maxHeightReached;
  bool get isPlaying => _isPlaying;

  bool get isFinished => _currentHeight <= 0 && _currentTime > 0;

  // Setters
  void setParameters({
    double? height,
    double? gravity,
    double? velocity,
    double? mass,
    bool? airResistance,
    double? dragCoeff,
  }) {
    if (height != null) _initialHeight = height;
    if (gravity != null) _gravity = gravity;
    if (velocity != null) _initialVelocity = velocity;
    if (mass != null) _mass = mass;
    if (airResistance != null) _airResistanceEnabled = airResistance;
    if (dragCoeff != null) _dragCoefficient = dragCoeff;

    reset();
    notifyListeners();
  }

  void play() {
    if (_isPlaying || isFinished) return;
    _isPlaying = true;
    notifyListeners();

    // 60 FPS ticker (dt = 0.016s)
    const double dt = 0.016;
    const duration = Duration(milliseconds: 16);

    _timer = Timer.periodic(duration, (timer) {
      if (!_isPlaying) {
        timer.cancel();
        return;
      }

      _stepPhysics(dt);
      notifyListeners();
    });
  }

  void _stepPhysics(double dt) {
    // Forces
    // Gravity: Fg = m * g (downwards)
    // Drag: Fd = -k * v (opposes velocity) - Simplified linear drag or quadratic?
    // Let's use quadratic drag for more realism: Fd = 0.5 * rho * Cd * A * v^2 * sign(-v)
    // Or simplified: F_drag = -k * v (linear) or -k * v * |v| (quadratic)
    // Let's stick to a simple k * v for elementary school understanding, or k * v^2.
    // Let's use F_drag = -k * v (Linear is easier to explain: "Friction proportional to speed")
    // But for free fall, quadratic is often better. Let's use Linear for simplicity unless requested otherwise.
    // Actually, let's use: F_net = F_gravity + F_drag
    // F_gravity = -m * g (assuming up is positive y)
    // F_drag = -k * v

    // Note: Our coordinate system:
    // y = height (up is positive)
    // g is magnitude (9.81)

    double forceGravity = -_mass * _gravity;
    double forceDrag = 0.0;

    if (_airResistanceEnabled) {
      forceDrag = -_dragCoefficient * _currentVelocity;
    }

    double netForce = forceGravity + forceDrag;
    double acceleration = netForce / _mass;

    // Euler Integration
    _currentVelocity += acceleration * dt;
    _currentHeight += _currentVelocity * dt;
    _currentTime += dt;

    // Track max height for zooming
    if (_currentHeight > _maxHeightReached) {
      _maxHeightReached = _currentHeight;
    }

    // Ground collision
    if (_currentHeight <= 0) {
      _currentHeight = 0;
      // _currentVelocity = 0; // Keep impact velocity for display? Or zero it?
      // Let's pause on impact
      pause();
    }
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    pause();
    _currentTime = 0.0;
    _currentHeight = _initialHeight;
    _currentVelocity =
        _initialVelocity; // Note: if v0 is positive, it goes UP first.
    _maxHeightReached = max(_initialHeight, 0);
    notifyListeners();
  }
}
