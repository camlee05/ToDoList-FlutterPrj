import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tasks;
  final Color color;
  final IconData icon;

  const GroupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tasks,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.9), size: 28),
            const SizedBox(height: 10),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Tasks: $tasks",
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
