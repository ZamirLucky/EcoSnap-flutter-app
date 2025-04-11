
import 'dart:io';

import 'package:camera/camera.dart';
//import 'package:device_info_plus/device_info_plus.dart';
import 'package:ecosnap/screens/display_picture_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecosnap/models/post.dart';
import 'package:ecosnap/widgets/category_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:flutter/services.dart';

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

  //track the selected color
  CategoryLabel? _selectedCategory = CategoryLabel.litter;

  // Declare instance
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  @override
  void dispose() {

    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> showLocalNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'post_created_channel', 
      'EcoSnap Notifications', 
      channelDescription: 'Channel for post confirmation',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,

      // 🔧 These help ensure visibility
      styleInformation: BigTextStyleInformation(
        'Your post was submitted successfully!',
        contentTitle: 'Post Created',
        htmlFormatContent: true,
        htmlFormatContentTitle: true,
      ),
    );

    const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      null,
      null,
      notificationDetails,
    );
  }
  
  // Function to set the image path
  Future<String> uploadImageToFirebase(String imagePath) async {
    try{
      File file = File(imagePath);
      String fileExtension = path.extension(imagePath);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      // create a reference to the Firebase Storage location
      Reference storageRef = FirebaseStorage.instance.ref().child('posts/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() => null);

      // Retrieve the download URL
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return '';
    }
  }


  Future<void> captureAndUploadImage() async {
    final ImagePicker picker = ImagePicker(); 

    final XFile? capturedPhoto = await picker.pickImage(source: ImageSource.camera);
    if (capturedPhoto != null) {
      if (kDebugMode) {
        print('========================================================= ');
        print('');
        print('Captured image path: ${capturedPhoto.path}');
        print('');
        print('========================================================= ');
      }

      final String firebaseImageUrl = await uploadImageToFirebase(capturedPhoto.path);
      if (kDebugMode) {
        print('========================================================= ');
        print('');
        print('Firebase image URL: $firebaseImageUrl');       
        print('');
        print('========================================================= ');
      }
      setState(() {
        _imageURL = firebaseImageUrl;
      });

      if (!context.mounted) return;
      // ignore: use_build_context_synchronously
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: capturedPhoto.path, 
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print('Image capture cancelled or failed.');
      }
    }
  }

  // Function to add a Post to Firebase Realtime Database
  Future<void> addPostToDatabase(AddPost post) async {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildVerticalLayout();
        } else if (constraints.maxWidth < 1200) {
          return _buildSideBySideLayout(isLarge: false);
        } else {
          return _buildSideBySideLayout(isLarge: true);
        }
      },
    );
  }


  Widget _buildVerticalLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildFormContent(),
      ),
    );
  }



  Widget _buildSideBySideLayout({required bool isLarge}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: _buildFormContent(),
            ),
          ),
        ],
      ),
    );
  }



  List<Widget> _buildFormContent() {
    return [
      const Text(
        "Capture Image",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      ElevatedButton.icon(
        icon: const Icon(Icons.camera_alt),
        label: const Text('Open Camera'),
        onPressed: () async {
          try {
            await captureAndUploadImage();
          } catch (e) {
            if (kDebugMode) {
              print('Error: $e');
            }
          }
        },
      ),

      const SizedBox(height: 20),
      DropdownMenu<CategoryLabel>(
        label: const Text('Select a category'),
        dropdownMenuEntries: CategoryLabel.entries,
        initialSelection: _selectedCategory,
        onSelected: (CategoryLabel? newCategory) {
          setState(() {
            _selectedCategory = newCategory;
          });
        },
      ),

      const SizedBox(height: 20),
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Title',
          hintText: 'Enter a short title, Maximum 100 characters',
        ),
      ),

      const SizedBox(height: 20),
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
      ElevatedButton(
        onPressed: () async {
          AddPost newPost = AddPost(
            title: _titleController.text,
            description: _descriptionController.text,
            imagePath: _imageURL,
            createdAt: _createdAt,
            userId: _userId,
            categoryId: (_selectedCategory!.index + 1).toString(),
          );
          await addPostToDatabase(newPost);
           await showLocalNotification();

          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post added successfully')),
          );
        },
        child: const Text('Create Post'),
      ),
    ];
  }





  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "Cupture Image",
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         // Capture button
  //         ElevatedButton.icon(
  //           icon: const Icon(Icons.camera_alt),
  //           label: const Text('Open Camera'),
  //           onPressed: () async{
  //             // Take the Picture in a try / catch block. If anything goes wrong,
  //             // catch the error.
  //             try {
  //               // Ensure that the camera is initialized.
  //               await captureAndUploadImage();
  //             } catch (e) {
  //               // If an error occurs, log the error to the console.
  //               if (kDebugMode) {
  //                 print(' ');
  //                 print('Error ocurred while taking the picture ======================================= ');
  //                 print(e);
  //               }
  //             }
  //           },
  //         ),
          
  //         const SizedBox(height: 20),
  //         // Material 3 DropdownMenu for selecting a Category
  //         DropdownMenu<CategoryLabel>(
  //           label: const Text('Select a category'),

  //           dropdownMenuEntries: CategoryLabel.entries,


  //           initialSelection: _selectedCategory,


  //           onSelected: (CategoryLabel? newCategory) {
  //             setState(() {
  //               _selectedCategory = newCategory;
  //             });
  //           },
  //         ),

  //         const SizedBox(height: 20),

  //         // Title text field
  //         TextField(
  //           controller: _titleController,
  //           decoration: const InputDecoration(
  //              border: OutlineInputBorder(),
  //             labelText: 'Title',
  //             hintText: 'Enter a short title, Maximum 100 characters',
  //           ),
  //         ),

  //         const SizedBox(height: 20),

  //         // Description text field
  //         TextField(
  //           controller: _descriptionController,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(),
  //             labelText: 'Description',
  //             hintText: 'Enter a description',
  //           ),
  //           maxLines: 3,
  //         ),

  //         const SizedBox(height: 20),
  //         // Submit button
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (kDebugMode) {
  //               print('Submitted text: ${_titleController.text}');
  //               print('Submitted text: ${_descriptionController.text}');
  //               print('Selected Category: $_selectedCategory');
  //               print(' ');
  //               print(' ');
  //               print('Created at: $_createdAt');
  //               print('User ID: $_userId');
  //               print('Image Path: $_imageURL');
  //             }           

  //             // Create a Post instance using current values and current time
  //             // Add the Post instance to the list of posts
  //             AddPost newPost = AddPost(
  //               title: _titleController.text,
  //               description: _descriptionController.text,
  //               imagePath: _imageURL,
  //               createdAt: _createdAt,
  //               userId: _userId,
  //               categoryId: _selectedCategory!.index.toString(),
  //             );
              
  //             await addPostToDatabase(newPost);
  //             // ignore: use_build_context_synchronously
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text('Post added successfully')),
  //             );

  //           },
  //           child: const Text('Create Post'),
  //         ),
  //       ],
  //   ),
  //   );
  // }
}