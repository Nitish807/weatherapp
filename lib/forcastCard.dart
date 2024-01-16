import 'package:flutter/material.dart';

class forcastCard extends StatelessWidget {
  final String time;
  final String tem;
  final IconData icon;
  const forcastCard({super.key, required this.time, required this.tem, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [Text(time),SizedBox(height: 8,), Icon(icon), SizedBox(height: 8,) ,Text(tem)],
          ),
        ),
      ),
    );
  }
}