import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../screens/breathing_screen.dart'; 

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBackButton;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B), 
      extendBodyBehindAppBar: true, 
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Varsayılan geri tuşunu iptal ettik
        
        // YENİ GERİ BUTONU MANTIĞI: Hep ana sayfaya (stack'in en altına) döner
        leading: showBackButton ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () {
            // route.isFirst, Ana Sayfaya gelene kadar açık olan tüm sayfaları kapatır
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ) : null,

        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE2E8F0), 
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ),
      
      body: Stack(
        children: [
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 350, height: 350,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3A86FF).withOpacity(0.15)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
            ),
          ),
          
          Positioned(
            bottom: -50, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF00B4DB).withOpacity(0.1)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
            ),
          ),

          SafeArea(bottom: false, child: body),

          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BreathingScreen()));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), 
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08), 
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 1)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.self_improvement_rounded, color: Colors.blue.shade200, size: 24),
                          const SizedBox(width: 12),
                          const Text("Mola Ver", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}