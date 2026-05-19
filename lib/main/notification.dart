import 'package:flutter/material.dart';
import 'package:test_vuln/services/hive_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> flags = [];
    try {
      flags = HiveService.getAllMissions()
        .where((m) => HiveService.isMissionCompleted(m['id'] as String))
        .map((m) => m['flag'] as String? ?? 'ETHIX{FLAG_${m['id']}}')
        .toList();
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2A),
      appBar: AppBar(
        title: const Text('Claimed Flags',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D142C),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context))),
      body: flags.isEmpty
        ? const Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag_outlined, color: Colors.white30, size: 64),
              SizedBox(height: 16),
              Text('No flags claimed yet.\nComplete missions to earn flags!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 14)),
            ]))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flags.length,
            itemBuilder: (context, i) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFFE68C8C).withOpacity(0.15),
                  Colors.black.withOpacity(0.5)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE68C8C).withOpacity(0.3))),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE68C8C).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE68C8C).withOpacity(0.5))),
                  child: const Icon(Icons.flag, color: Color(0xFFE68C8C), size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Text(flags[i],
                  style: const TextStyle(color: Color(0xFFE68C8C), fontSize: 14,
                    fontFamily: 'monospace', fontWeight: FontWeight.bold))),
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ]))));
  }
}
