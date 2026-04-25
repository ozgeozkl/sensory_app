import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final bool showBackButton;

  const BaseScaffold({
    super.key,
    required this.body,
    required this.title,
    this.showBackButton = true,
  });

  void _triggerSOS(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A2E),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.air, color: Colors.tealAccent, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Sadece nefesine odaklan...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Daha İyiyim", style: TextStyle(fontSize: 18, color: Colors.white70)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w300)),
        centerTitle: true,
        automaticallyImplyLeading: showBackButton,
      ),
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _triggerSOS(context),
        backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.9),
        elevation: 0,
        highlightElevation: 0,
        icon: const Icon(Icons.spa_rounded, size: 26, color: Colors.white),
        label: const Text(
          "Mola Ver", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1.2, color: Colors.white),
        ),
      ),
    );
  }
}