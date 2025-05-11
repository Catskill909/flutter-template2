import 'package:flutter/material.dart';

class Tab3Screen extends StatelessWidget {
  const Tab3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 80,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Tab 3 Content',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This is a placeholder for Tab 3 content',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
