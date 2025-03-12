import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class StatsSummaryScreen extends StatefulWidget {
  const StatsSummaryScreen({super.key});

  @override
  _StatsSummaryScreenState createState() => _StatsSummaryScreenState();
}

class _StatsSummaryScreenState extends State<StatsSummaryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Map<String, int> weeklyStats = {};
  Map<String, int> monthlyStats = {};
  Map<String, int> yearlyStats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));
    final yearAgo = now.subtract(const Duration(days: 365));

    final weekly = await _dbHelper.getStatsByRange(_formatDate(weekAgo), _formatDate(now));
    final monthly = await _dbHelper.getStatsByRange(_formatDate(monthAgo), _formatDate(now));
    final yearly = await _dbHelper.getStatsByRange(_formatDate(yearAgo), _formatDate(now));

    setState(() {
      weeklyStats = _calculateStats(weekly);
      monthlyStats = _calculateStats(monthly);
      yearlyStats = _calculateStats(yearly);
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Map<String, int> _calculateStats(List<Map<String, dynamic>> stats) {
    int pomodoroCount = 0, startCount = 0, stopCount = 0, successCount = 0;
    for (var stat in stats) {
      pomodoroCount += stat['pomodoroCount'] as int;
      startCount += stat['startCount'] as int;
      stopCount += stat['stopCount'] as int;
      successCount += stat['successCount'] as int;
    }
    return {
      'Pomodoro': pomodoroCount,
      'Start': startCount,
      'Stop': stopCount,
      'Success': successCount,
    };
  }

  Widget _buildStatsCard(String title, Map<String, int> stats) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (var entry in stats.entries)
              Text('${entry.key}: ${entry.value}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สถิติรายสัปดาห์/เดือน/ปี')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatsCard('สถิติรายสัปดาห์', weeklyStats),
            _buildStatsCard('สถิติรายเดือน', monthlyStats),
            _buildStatsCard('สถิติรายปี', yearlyStats),
          ],
        ),
      ),
    );
  }
}
