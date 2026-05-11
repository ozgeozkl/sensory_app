import 'package:flutter/material.dart';
import 'dart:async'; // Timer için eklendi
import '../widgets/base_scaffold.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});
  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool _isActive = false;
  double _circleSize = 150.0;
  int _animationDuration = 2; 
  String _mainText = "Başlamak için dokun";
  
  Timer? _timer;
  int _secondsLeft = 4;
  int _currentPhase = 0; // 0: Al, 1: Tut, 2: Ver, 3: Bekle

  @override
  void dispose() {
    _timer?.cancel(); // Sayfadan çıkıldığında sayacı durdur
    super.dispose();
  }

  void _toggleBreathing() {
    if (_isActive) {
      _stopBreathing();
    } else {
      _startBreathing();
    }
  }

  void _stopBreathing() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _circleSize = 150.0;
      _animationDuration = 2; 
      _mainText = "Başlamak için dokun";
    });
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _currentPhase = 0;
      _secondsLeft = 4;
    });
    _updatePhaseUI();

    // Saniye saniye geri sayan ve aşamaları yöneten Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _currentPhase = (_currentPhase + 1) % 4; // 0, 1, 2, 3 arası döngü
          _secondsLeft = 4; // Her aşama 4 saniye
          _updatePhaseUI();
        }
      });
    });
  }

  void _updatePhaseUI() {
    switch (_currentPhase) {
      case 0:
        _circleSize = 300.0; 
        _animationDuration = 4;
        _mainText = "Nefes Al";
        break;
      case 1:
        _animationDuration = 4;
        _mainText = "Tut";
        break;
      case 2:
        _circleSize = 150.0; 
        _animationDuration = 4;
        _mainText = "Nefes Ver";
        break;
      case 3:
        _animationDuration = 4;
        _mainText = "Bekle";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Nefes Egzersizi",
      body: GestureDetector(
        onTap: _toggleBreathing,
        behavior: HitTestBehavior.opaque, 
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2), 

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _mainText,
                  key: ValueKey<String>(_mainText),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: Colors.teal.shade100,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              
              const Spacer(flex: 1), 

              AnimatedContainer(
                duration: Duration(seconds: _animationDuration),
                curve: Curves.easeInOutSine, 
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.withOpacity(_circleSize == 300.0 ? 0.6 : 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.tealAccent.withOpacity(_circleSize == 300.0 ? 0.4 : 0.0),
                      blurRadius: _circleSize == 300.0 ? 60 : 0,
                      spreadRadius: _circleSize == 300.0 ? 20 : 0,
                    )
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isActive 
                      ? Text(
                          "$_secondsLeft", // ORTADAKİ DEV SAYAÇ
                          key: ValueKey<int>(_secondsLeft),
                          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 60, color: Colors.white54),
                  ),
                ),
              ),
              
              const Spacer(flex: 2), 
            ],
          ),
        ),
      ),
    );
  }
}