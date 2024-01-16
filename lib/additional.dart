import 'package:flutter/material.dart';
 
class additionalifo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const additionalifo({super.key,  required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Column(
              children: [
                 Icon(icon,
                 size: 32,),
                SizedBox(height: 8,),
                Text(label),
                SizedBox(
                  height: 5,
                ),
                Text(value,style: TextStyle(fontSize: 16),)
              ],
            );
  }
}