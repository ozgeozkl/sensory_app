import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
import '../widgets/base_scaffold.dart';

// ==========================================
// ANA SAYFA: GÖRSEL DENEYİMLER
// ==========================================
class VisualsScreen extends StatefulWidget {
  const VisualsScreen({super.key});
  @override
  State<VisualsScreen> createState() => _VisualsScreenState();
}

class _VisualsScreenState extends State<VisualsScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Görsel Deneyimler",
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: const [
              CloudyPage(),      
              StarryNightPage(), 
              FluidFollowPage(), 
            ],
          ),
          
          Positioned(
            bottom: 45, left: 20,
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white.withOpacity(0.5), size: 36),
          ),
          
          Positioned(
            bottom: 45, right: 20,
            child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: 36),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 1. MOD: BULUTLU GÜNDÜZ GÖKYÜZÜ (SAYAÇLI)
// ==========================================
class CloudyPage extends StatefulWidget {
  const CloudyPage({super.key});
  @override
  State<CloudyPage> createState() => _CloudyPageState();
}

class _CloudyPageState extends State<CloudyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<List<double>> _clouds = [];
  
  // Bulut sayacı
  int _poppedClouds = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      _clouds.add([_random.nextDouble() * 800, _random.nextDouble() * 800, 0.2 + _random.nextDouble() * 0.8, 0.6 + _random.nextDouble() * 1.5, 0.7 + _random.nextDouble() * 0.3]);
    }
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(() {
        setState(() {
          for (var cloud in _clouds) {
            cloud[0] -= cloud[2]; 
            if (cloud[0] < -300) {
              cloud[0] = MediaQuery.of(context).size.width + 50;
              cloud[1] = _random.nextDouble() * MediaQuery.of(context).size.height * 0.8; 
            }
          }
        });
      });
    _controller.repeat(); 
  }

  @override
  void dispose() { 
    _controller.dispose(); 
    super.dispose(); 
  }

  void _popCloud(int index) {
    // Eğer bulut zaten dağıtılıyorsa sayacı tekrar artırma
    if (_clouds[index][4] == 0.0) return; 

    setState(() { 
      _poppedClouds++; // Sayacı artır
      _clouds[index][4] = 0.0; 
      _clouds[index][3] *= 1.5; 
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() { _clouds[index][0] = MediaQuery.of(context).size.width + 50; _clouds[index][4] = 0.8; _clouds[index][3] /= 1.5; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF4A90E2), Color(0xFFE3F2FD)])),
          child: Stack(
            children: _clouds.asMap().entries.map((entry) {
              return Positioned(
                left: entry.value[0], top: entry.value[1],
                child: GestureDetector(
                  onTap: () => _popCloud(entry.key), 
                  child: AnimatedOpacity(duration: const Duration(milliseconds: 800), opacity: entry.value[4], child: AnimatedScale(duration: const Duration(milliseconds: 800), scale: entry.value[3], child: const CloudShape())),
                ),
              );
            }).toList(),
          ),
        ),
        
        // SAYAÇ VE YÖNERGE BÖLÜMÜ
        Positioned(
          top: 30, left: 0, right: 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  "Dağıtılan Bulut: $_poppedClouds",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Dağıtmak için bulutlara dokun", 
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1.5)
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CloudShape extends StatelessWidget {
  const CloudShape({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, height: 100,
      child: Stack(clipBehavior: Clip.none, children: [
        Positioned(bottom: 10, left: 20, child: Container(width: 120, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)))),
        Positioned(bottom: 20, left: 30, child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle))),
        Positioned(bottom: 25, left: 55, child: Container(width: 65, height: 65, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle))),
        Positioned(bottom: 15, left: 95, child: Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle))),
      ]),
    );
  }
}

// ==========================================
// 2. MOD: YILDIZLI GECE (SAYAÇLI)
// ==========================================
class StarryNightPage extends StatefulWidget {
  const StarryNightPage({super.key});
  @override
  State<StarryNightPage> createState() => _StarryNightPageState();
}

class _StarryNightPageState extends State<StarryNightPage> {
  final List<Widget> _activeShootingStars = [];
  final Random _random = Random();
  final List<Offset> _backgroundStars = [];
  
  // Yıldız sayacı
  int _shootingStars = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 150; i++) _backgroundStars.add(Offset(_random.nextDouble(), _random.nextDouble()));
  }

  void _spawnShootingStar(Offset position) {
    final Key starKey = UniqueKey(); 
    setState(() {
      _shootingStars++; // Sayacı artır
      _activeShootingStars.add(ShootingStarEffect(
        key: starKey, startPosition: position, angle: _random.nextDouble() * 2 * pi,
        onComplete: () { if (mounted) setState(() => _activeShootingStars.removeWhere((w) => w.key == starKey)); },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _spawnShootingStar(details.localPosition),
      behavior: HitTestBehavior.opaque, 
      child: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF020024), Color(0xFF090979), Color(0xFF00d4ff)])),
        child: Stack(
          children: [
            ..._backgroundStars.map((pos) => Positioned(left: pos.dx * MediaQuery.of(context).size.width, top: pos.dy * MediaQuery.of(context).size.height, child: Container(width: _random.nextDouble() * 2 + 1, height: _random.nextDouble() * 2 + 1, decoration: BoxDecoration(color: Colors.white.withOpacity(_random.nextDouble() * 0.8 + 0.2), shape: BoxShape.circle)))),
            ..._activeShootingStars,
            
            // SAYAÇ VE YÖNERGE BÖLÜMÜ
            Positioned(
              top: 30, left: 0, right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: Text(
                      "Kayan Yıldız: $_shootingStars",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Yıldız kaydırmak için gökyüzüne dokun", 
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1.5)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShootingStarEffect extends StatelessWidget {
  final Offset startPosition; final double angle; final VoidCallback onComplete;
  const ShootingStarEffect({super.key, required this.startPosition, required this.angle, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0), duration: const Duration(milliseconds: 800), curve: Curves.easeOutQuad, onEnd: onComplete, 
      builder: (context, value, child) {
        return Positioned(
          left: startPosition.dx + cos(angle) * 300.0 * value, top: startPosition.dy + sin(angle) * 300.0 * value,
          child: Opacity(
            opacity: 1.0 - value,
            child: Transform.rotate(angle: angle, child: Container(width: 60, height: 3, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.0)], begin: Alignment.centerRight, end: Alignment.centerLeft), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.8), blurRadius: 10, spreadRadius: 1)]))),
          ),
        );
      },
    );
  }
}

// ==========================================
// 3. MOD: AKIŞKAN RENKLER & IŞIK TAKİBİ
// ==========================================
class FluidTheme {
  final String name;
  final List<Color> colors;
  FluidTheme(this.name, this.colors);
}

class FluidFollowPage extends StatefulWidget {
  const FluidFollowPage({super.key});
  @override
  State<FluidFollowPage> createState() => _FluidFollowPageState();
}

class _FluidFollowPageState extends State<FluidFollowPage> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _time = 0.0; 

  Offset _pointer = const Offset(-1000, -1000); 
  final List<TrailPoint> _trail = [];
  
  final List<FluidTheme> _themes = [
    FluidTheme("Okyanus", [const Color(0xFF001F3F), const Color(0xFF00E5FF), const Color(0xFF0074D9)]),
    FluidTheme("Gün Batımı", [const Color(0xFF85144b), const Color(0xFFFF851B), const Color(0xFFFFDC00)]),
    FluidTheme("Orman", [const Color(0xFF002100), const Color(0xFF3D9970), const Color(0xFF2ECC40)]),
    FluidTheme("Galaksi", [const Color(0xFF020024), const Color(0xFF090979), const Color(0xFF4B0082)]),
  ];
  late FluidTheme _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = _themes[0]; 

    _ticker = createTicker((elapsed) {
      setState(() {
        _time += 0.015; 
        final now = DateTime.now();
        _trail.removeWhere((p) => now.difference(p.time).inMilliseconds > 1000);
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _addTrailPoint(Offset pos) {
    setState(() {
      _pointer = pos;
      _trail.add(TrailPoint(position: pos, time: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Tema", style: TextStyle(fontSize: 16)),
        actions: [
          PopupMenuButton<FluidTheme>(
            icon: const Icon(Icons.palette_outlined, color: Colors.white),
            color: Colors.black87,
            onSelected: (FluidTheme val) => setState(() => _currentTheme = val),
            itemBuilder: (context) => _themes.map((t) => 
              PopupMenuItem(value: t, child: Text(t.name, style: const TextStyle(color: Colors.white)))
            ).toList(),
          )
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) => _addTrailPoint(details.localPosition),
        onPanDown: (details) => _addTrailPoint(details.localPosition),
        onTapDown: (details) => _addTrailPoint(details.localPosition),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: FluidInteractionPainter(
                  time: _time,
                  themeColors: _currentTheme.colors,
                  pointer: _pointer,
                  trail: _trail,
                ),
              ),
            ),
            Positioned(
              top: 40, left: 0, right: 0,
              child: Center(
                child: Text(
                  "Işığı yönlendirmek için ekrana dokun",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrailPoint {
  final Offset position;
  final DateTime time;
  TrailPoint({required this.position, required this.time});
}

class FluidInteractionPainter extends CustomPainter {
  final double time;
  final List<Color> themeColors;
  final Offset pointer;
  final List<TrailPoint> trail;

  FluidInteractionPainter({required this.time, required this.themeColors, required this.pointer, required this.trail});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Color c1 = themeColors[0];
    final Color c2 = themeColors[1];
    final Color c3 = themeColors[2];

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = c1);

    void drawFluidBlob(double cx, double cy, double radius, Color color) {
      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.0)],
        ).createShader(rect);
      canvas.drawRect(rect, paint);
    }

    drawFluidBlob(w/2 + sin(time * 0.8) * w * 0.4, h/2 + cos(time * 0.6) * h * 0.4, w * 0.6, c2);
    drawFluidBlob(w/2 + cos(time * 0.5) * w * 0.5, h/2 + sin(time * 0.7) * h * 0.5, w * 0.6, c3);
    drawFluidBlob(w/2 + sin(time * 0.9) * w * 0.3, h/2 + cos(time * 0.8) * h * 0.4, w * 0.5, c1);
    drawFluidBlob(w/2 + cos(time * 0.4) * w * 0.4, h/2 + sin(time * 0.5) * h * 0.4, w * 0.7, c3);
    drawFluidBlob(w/2 + sin(time * 0.6) * w * 0.5, h/2 + cos(time * 0.4) * h * 0.5, w * 0.5, c2);

    final now = DateTime.now();

    for (var point in trail) {
      final int age = now.difference(point.time).inMilliseconds;
      final double lifeRatio = 1.0 - (age / 1000).clamp(0.0, 1.0); 
      final Paint trailPaint = Paint()..color = Colors.white.withOpacity(lifeRatio * 0.5)..style = PaintingStyle.fill;
      canvas.drawCircle(point.position, 20 * lifeRatio, trailPaint); 
    }

    final Paint glowPaint = Paint()..color = Colors.white.withOpacity(0.3)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final Paint corePaint = Paint()..color = Colors.white;
    canvas.drawCircle(pointer, 15, glowPaint); 
    canvas.drawCircle(pointer, 6, corePaint);  
  }

  @override
  bool shouldRepaint(covariant FluidInteractionPainter oldDelegate) => true; 
}
