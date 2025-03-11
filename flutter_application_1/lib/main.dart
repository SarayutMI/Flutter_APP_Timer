import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'dart:async';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData.dark(),
      home: const PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int workTime = 25;
  int breakTime = 5;
  int secondsLeft = 25 * 60;
  bool isRunning = false;
  Timer? timer;
  int pomodoroCount = 0;
  int startCount = 0;
  int stopCount = 0;
  int successCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _startTimer() {
    if (isRunning) return;
    setState(() {
      isRunning = true;
      startCount++;
    });
    _saveStats();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        _stopTimer();
        setState(() {
          pomodoroCount++;
          successCount++;
        });
        _saveStats();
      }
    });
  }

  void _stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      stopCount++;
    });
    _saveStats();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() => secondsLeft = workTime * 60);
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pomodoroCount = prefs.getInt('pomodoroCount') ?? 0;
      startCount = prefs.getInt('startCount') ?? 0;
      stopCount = prefs.getInt('stopCount') ?? 0;
      successCount = prefs.getInt('successCount') ?? 0;
    });
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodoroCount', pomodoroCount);
    await prefs.setInt('startCount', startCount);
    await prefs.setInt('stopCount', stopCount);
    await prefs.setInt('successCount', successCount);
  }

  String get timerText {
    int minutes = secondsLeft ~/ 60;
    int seconds = secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(
                  workTime: workTime,
                  breakTime: breakTime,
                  onSettingsChanged: (newWorkTime, newBreakTime) {
                    setState(() {
                      workTime = newWorkTime;
                      breakTime = newBreakTime;
                      secondsLeft = workTime * 60;
                    });
                  },
                )),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatsScreen(
                  pomodoroCount: pomodoroCount,
                  startCount: startCount,
                  stopCount: stopCount,
                  successCount: successCount,
                )),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(timerText, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startTimer,
                child: const Text('Start'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _stopTimer,
                child: const Text('Stop'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetTimer,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}