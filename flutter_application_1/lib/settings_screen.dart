import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final int workTime;
  final int breakTime;
  final Function(int, int) onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.workTime,
    required this.breakTime,
    required this.onSettingsChanged,
  });

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late int workTime;
  late int breakTime;

  @override
  void initState() {
    super.initState();
    workTime = widget.workTime;
    breakTime = widget.breakTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตั้งค่าจับเวลา')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('เวลาโฟกัส (นาที)', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: workTime.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '$workTime นาที',
              onChanged: (value) {
                setState(() => workTime = value.toInt());
              },
            ),
            const SizedBox(height: 20),
            Text('เวลาพัก (นาที)', style: Theme.of(context).textTheme.titleLarge),
            Slider(
              value: breakTime.toDouble(),
              min: 1,
              max: 30,
              divisions: 10,
              label: '$breakTime นาที',
              onChanged: (value) {
                setState(() => breakTime = value.toInt());
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                widget.onSettingsChanged(workTime, breakTime);
                Navigator.pop(context);
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}