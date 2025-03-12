import 'package:flutter/material.dart';
import 'StatsSummaryScreen.dart';
class StatsScreen extends StatelessWidget {
  final int pomodoroCount;
  final int startCount;
  final int stopCount;
  final int successCount;

  const StatsScreen({
    super.key,
    required this.pomodoroCount,
    required this.startCount,
    required this.stopCount,
    required this.successCount,
  });

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('สถิติ Pomodoro')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('จำนวนรอบสำเร็จ', successCount),
          _buildStatCard('จำนวนรอบ Pomodoro', pomodoroCount),
          _buildStatCard('กดเริ่มจับเวลา', startCount),
          _buildStatCard('กดหยุดจับเวลา', stopCount),
          const SizedBox(height: 20), // เพิ่มระยะห่างเล็กน้อย
          Center( // จัดให้ปุ่มอยู่ตรงกลาง
            child: IconButton(
              icon: const Icon(Icons.date_range, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsSummaryScreen()),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildStatCard(String title, int value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}