import 'package:ecosnap/widgets/create_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // If you have a custom app bar, you can place it here or
      // you can leave it for later as you mentioned.
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: const CreatePostWidget(),
        // If you already have a custom bottom navigation bar,
        // you can add it here:
        // bottomNavigationBar: YourCustomBottomNavBar(),
      
    );
  }
}