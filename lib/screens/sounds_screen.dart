import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/base_scaffold.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({super.key});
  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex;

  final List<Map<String, dynamic>> _soundList = [
    {"name": "Hafif Yağmur", "icon": Icons.water_drop, "path": "sounds/light-rain.wav"},
    {"name": "Orman Uğultusu", "icon": Icons.forest, "path": "sounds/forest-birds.wav"},
    {"name": "Okyanus Dalgaları", "icon": Icons.waves, "path": "sounds/sea-waves.wav"},
    {"name": "Beyaz Gürültü", "icon": Icons.air, "path": "sounds/white-noise.mp3"},
  ];

  @override
  void dispose() {
    _audioPlayer.dispose(); 
    super.dispose();
  }

  void _togglePlay(int index) async {
    if (_currentlyPlayingIndex == index) {
      await _audioPlayer.stop();
      setState(() => _currentlyPlayingIndex = null);
    } else {
      setState(() => _currentlyPlayingIndex = index);
      await _audioPlayer.play(AssetSource(_soundList[index]["path"])); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Sakinleştirici Sesler",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Zihnini dinlendirecek bir ses seç", style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w300)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _soundList.length,
                itemBuilder: (context, index) {
                  final sound = _soundList[index];
                  final isPlaying = _currentlyPlayingIndex == index;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isPlaying ? Colors.teal.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isPlaying ? Colors.tealAccent.withOpacity(0.5) : Colors.transparent),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Icon(sound["icon"], color: isPlaying ? Colors.tealAccent : Colors.white54, size: 32),
                      title: Text(sound["name"], style: TextStyle(fontSize: 18, color: isPlaying ? Colors.white : Colors.white70, fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal)),
                      trailing: IconButton(
                        icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline, color: isPlaying ? Colors.tealAccent : Colors.white, size: 36),
                        onPressed: () => _togglePlay(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}