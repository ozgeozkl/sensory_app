import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/base_scaffold.dart';

// ==========================================
// GLOBAL SES SERVİSİ (SINGLETON)
// Bu servis sayesinde sesler sayfadan çıkılsa bile arkada çalmaya devam eder.
// ==========================================
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    // Sesin bitince otomatik olarak baştan başlamasını (loop) sağlar
    player.setReleaseMode(ReleaseMode.loop);
  }

  final AudioPlayer player = AudioPlayer();
  
  // Hangi sesin çaldığını uygulama genelinde takip etmek için ValueNotifier kullanıyoruz
  final ValueNotifier<int?> currentlyPlayingIndex = ValueNotifier<int?>(null);

  Future<void> togglePlay(int index, String path) async {
    if (currentlyPlayingIndex.value == index) {
      // Aynı sese tekrar basılırsa durdur
      await player.stop();
      currentlyPlayingIndex.value = null;
    } else {
      // Farklı bir sese basılırsa onu çal
      currentlyPlayingIndex.value = index;
      await player.play(AssetSource(path)); 
    }
  }
}

// ==========================================
// SESLER SAYFASI ARAYÜZÜ
// ==========================================
class SoundsScreen extends StatefulWidget {
  const SoundsScreen({super.key});
  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  // Global servisimizi çağırıyoruz
  final AudioService _audioService = AudioService();

  final List<Map<String, dynamic>> _soundList = [
    {"name": "Hafif Yağmur", "icon": Icons.water_drop, "path": "sounds/light-rain.wav"},
    {"name": "Kuş Sesleri", "icon": Icons.forest, "path": "sounds/forest-birds.wav"},
    {"name": "Okyanus Dalgaları", "icon": Icons.waves, "path": "sounds/sea-waves.wav"},
    {"name": "Beyaz Gürültü", "icon": Icons.air, "path": "sounds/white-noise.mp3"},
  ];

  @override
  void dispose() {
    //  sayfadan çıkılsa bile servis arkada yaşamaya devam ediyor.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Sesler",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Arka Planda çalması için bir ses seç", 
              style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w300)
            ),
            const SizedBox(height: 30),
            Expanded(
              // ValueListenableBuilder: Sayfaya geri dönüldüğünde hangi sesin çaldığını hatırlar ve UI'ı günceller
              child: ValueListenableBuilder<int?>(
                valueListenable: _audioService.currentlyPlayingIndex,
                builder: (context, playingIndex, child) {
                  return ListView.builder(
                    itemCount: _soundList.length,
                    itemBuilder: (context, index) {
                      final sound = _soundList[index];
                      final isPlaying = playingIndex == index;
                      
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
                          title: Text(
                            sound["name"], 
                            style: TextStyle(
                              fontSize: 18, 
                              color: isPlaying ? Colors.white : Colors.white70, 
                              fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal
                            )
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline, 
                              color: isPlaying ? Colors.tealAccent : Colors.white, 
                              size: 36
                            ),
                            onPressed: () => _audioService.togglePlay(index, sound["path"]),
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }
}