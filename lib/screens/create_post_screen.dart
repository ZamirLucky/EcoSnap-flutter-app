import 'package:camera/camera.dart';
import 'package:ecosnap/widgets/create_post_widget.dart';
import 'package:flutter/material.dart';


class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late Future<CameraDescription> _cameraFuture;

  @override
  void initState() {
    super.initState();
    _cameraFuture = _initCamera();
  }

  Future<CameraDescription> _initCamera() async {
    // Ensure that plugin services are initialized.
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Return the first camera.
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraDescription>(
      future: _cameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Create Post')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Post')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          // When the camera is available, pass it to the CreatePostWidget.
          final firstCamera = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Post'),
            ),
            body: CreatePostWidget(camera: firstCamera),
          );
        }
      },
    );
  }
}