
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecosnap/screens/display_picture_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:ecosnap/models/post.dart';
import 'package:ecosnap/widgets/category_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({super.key, required this.camera});
  final CameraDescription camera; 

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final String _createdAt = DateTime.now().toIso8601String();
  final String _userId = 'exampleUserId';
  String _imageURL = '';

  // camera controller and future to initialize it 
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture; 

  //track the selected color
  CategoryLabel? _selectedCategory = CategoryLabel.litter;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
      _cameraController = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );
      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // Function to set the image path
  Future<String> uploadImageToFirebase(String imagePath) async {
    // Upload the image to Firebase Storage and get the download URL
    File file = File(imagePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    // create a reference to the Firebase Storage location
    Reference storageRef = FirebaseStorage.instance.ref().child('posts/$fileName');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() => null);

    // Retrieve the download URL
    String downloadURL = await storageRef.getDownloadURL();
    return downloadURL;
  }

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
            onPressed: () async{
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final XFile image = await _cameraController.takePicture();

                // upload the image to Firebase and get the download URL
                final String firebaseImageUrl = await uploadImageToFirebase(image.path);
                setState(() {
                  _imageURL = firebaseImageUrl;
                });

                if (!context.mounted) return;

                // Navigate to the DisplayPictureScreen passing the new local image path.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                        ),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                if (kDebugMode) {
                  print(' ');
                  print('Error ocurred while taking the picture ======================================= ');
                  print(e);
                }
              }
            },
          ),
          
          const SizedBox(height: 20),
          // Material 3 DropdownMenu for selecting a Category
          DropdownMenu<CategoryLabel>(
            label: const Text('Select a category'),
            // The list of dropdown entries from your enum
            dropdownMenuEntries: CategoryLabel.entries,

            // The current selected value
            initialSelection: _selectedCategory,

            // Callback when a new color is selected
            onSelected: (CategoryLabel? newCategory) {
              setState(() {
                _selectedCategory = newCategory;
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
                print('Image Path: $_imageURL');
              }           

              // Create a Post instance using current values and current time
              // Add the Post instance to the list of posts
              AddPost newPost = AddPost(
                title: _titleController.text,
                description: _descriptionController.text,
                imagePath: _imageURL,
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