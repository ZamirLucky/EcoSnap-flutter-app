
import 'package:firebase_database/firebase_database.dart';


import 'package:ecosnap/models/post.dart';
import 'package:ecosnap/widgets/category_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key});

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final String _createdAt = DateTime.now().toIso8601String();
  final String _userId = 'exampleUserId';
  final String _imagePath = 'example/Image/Path';

  //track the selected color
  CategoryLabel? _selectedCategory = CategoryLabel.litter;
  
  // Function to add a Post to Firebase Realtime Database
  Future<void> addPostToDatabase(AddPost post) async {
    // Use push() to create a unique key for the new post
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('posts').push();
    await dbRef.set(post.toJson());
    if (kDebugMode) {
      print("Post added successfully");
      print(' ');
      print('======================================================================= ');
      print(' ');

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Cupture Image",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Capture button
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Open Camera'),
            onPressed: () {
              // Add your code here
            },
          ),
          
          const SizedBox(height: 20),
          // Material 3 DropdownMenu for selecting a color
          DropdownMenu<CategoryLabel>(
            label: const Text('Select a category'),
            // The list of dropdown entries from your enum
            dropdownMenuEntries: CategoryLabel.entries,

            // The current selected value
            initialSelection: _selectedCategory,

            // Callback when a new color is selected
            onSelected: (CategoryLabel? newColor) {
              setState(() {
                _selectedCategory = newColor;
              });
            },
          ),

          const SizedBox(height: 20),

          // Title text field
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
               border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter a short title, Maximum 100 characters',
            ),
          ),

          const SizedBox(height: 20),

          // Description text field
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'Enter a description',
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 20),
          // Submit button
          ElevatedButton(
            onPressed: () async {
              if (kDebugMode) {
                print('Submitted text: ${_titleController.text}');
                print('Submitted text: ${_descriptionController.text}');
                print('Selected Category: $_selectedCategory');
                print(' ');
                print(' ');
                print('Created at: $_createdAt');
                print('User ID: $_userId');
                print('Image Path: $_imagePath');
              }           
              // Add your code here
              // Create a Post instance using current values and current time
              // Add the Post instance to the list of posts
              AddPost newPost = AddPost(
                title: _titleController.text,
                description: _descriptionController.text,
                imagePath: _imagePath,
                createdAt: _createdAt,
                userId: _userId,
                categoryId: _selectedCategory!.index.toString(),
              );
              
              await addPostToDatabase(newPost);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post added successfully')),
              );

            },
            child: const Text('Create Post'),
          ),
        ],
    ),
    );
  }
}