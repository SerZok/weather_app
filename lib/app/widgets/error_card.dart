import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onReload;
  const ErrorCard({
    super.key,
    required this.title,
    required this.description,
    required this.onReload, 
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Text(description),
          ElevatedButton(
            onPressed: onReload,
            child: const Text('Reload'),
          )
        ],
      ),
    );
  }
}