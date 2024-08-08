import 'package:flutter/material.dart';

class WeekInfo extends StatelessWidget {
  final int index;
  
  const WeekInfo({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('임신 $index 주차'),
      ),
      body: Center(
        child: Text(
          '임신 $index 주차의 상세 정보',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
