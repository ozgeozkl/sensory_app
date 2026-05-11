import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import 'sounds_screen.dart';
import 'visuals_screen.dart';
import 'breathing_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Kozmos",
      showBackButton: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMenuCard(
              context, 
              title: "Sesler", 
              icon: Icons.water_drop_outlined, 
              color: Colors.blue.shade800,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SoundsScreen()))
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context, 
              title: "Animasyonlar", 
              icon: Icons.flare, 
              color: Colors.purple.shade800,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VisualsScreen()))
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context, 
              title: "Nefes Egzersizi", 
              icon: Icons.air, 
              color: Colors.teal.shade800,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BreathingScreen()))
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color.withOpacity(0.9)),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}