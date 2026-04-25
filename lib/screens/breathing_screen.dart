import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});
  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool _isActive = false;
  double _circleSize = 150.0;
  int _animationDuration = 1; 
  String _mainText = "Başlamak için dokun";
  String _subText = "Kutu Nefesi (4-4-4-4 Tekniği)";

  @override
  void dispose() {
    _isActive = false; 
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
    setState(() {
      _isActive = false;
      _circleSize = 150.0;
      _animationDuration = 2; 
      _mainText = "Başlamak için dokun";
      _subText = "Kutu Nefesi (4-4-4-4 Tekniği)";
    });
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
    });
    _runBreathingCycle();
  }

  void _runBreathingCycle() async {
    while (_isActive) {
      if (!mounted) return;

      setState(() {
        _circleSize = 300.0; 
        _animationDuration = 4;
        _mainText = "Nefes Al...";
        _subText = "Burnundan yavaşça (4 sn)";
      });
      await Future.delayed(const Duration(seconds: 4));
      if (!_isActive || !mounted) break;

      setState(() {
        _animationDuration = 4; 
        _mainText = "Tut...";
        _subText = "Nefesini içeride tut (4 sn)";
      });
      await Future.delayed(const Duration(seconds: 4));
      if (!_isActive || !mounted) break;

      setState(() {
        _circleSize = 150.0; 
        _animationDuration = 4;
        _mainText = "Nefes Ver...";
        _subText = "Ağzından yavaşça (4 sn)";
      });
      await Future.delayed(const Duration(seconds: 4));
      if (!_isActive || !mounted) break;

      setState(() {
        _animationDuration = 4; 
        _mainText = "Bekle...";
        _subText = "Nefes almadan bekle (4 sn)";
      });
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Nefes Akışı",
      body: GestureDetector(
        onTap: _toggleBreathing,
        behavior: HitTestBehavior.opaque, 
        child: Center(
          child: Column(
            children: [
              // 1. DÜZELTME: Üstten esnek boşluk (Ekranın üst kısmını dengeler)
              const Spacer(flex: 2), 

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _mainText,
                  key: ValueKey<String>(_mainText),
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w300,
                    color: Colors.teal.shade100,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _subText,
                  key: ValueKey<String>(_subText),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white54,
                  ),
                ),
              ),
              
              // 2. DÜZELTME: Metin ile çember arasında esnek boşluk
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
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _isActive ? 0.0 : 1.0, 
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
              
              // 3. DÜZELTME: Mola Ver butonuna kadar alt kısımda esnek boşluk
              const Spacer(flex: 2), 
            ],
          ),
        ),
      ),
    );
  }
}