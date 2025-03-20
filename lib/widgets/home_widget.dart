import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Center(
              child: Text(
                """EcoSnap helps you document environmental conditions and encourages mindful, eco-friendly habits.
                  To add a new capture, simply tap the "add" icon, snap a photo, and enter a title and description for your observation.
                  If you don’t have an account yet, please create one.
                  To view all the captures, click the button below!""",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0
                ),
                textStyle: const TextStyle(fontSize: 14),
              ),
              onPressed: () {
                // Navigate to the camera screen
              },
              child: const Text('Go to Captures'),
            ),
          ),
        ],
      ),
    );
  }
}
