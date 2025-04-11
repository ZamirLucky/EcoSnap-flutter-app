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

    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraDescription>(
      future: _cameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            // appBar: AppBar(title: const Text('Create Post'),
            //   centerTitle: true,
            // ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          // Camera is initialized, proceed with the CreatePostWidget
          final firstCamera = snapshot.data!;
          return Scaffold(
            // appBar: AppBar(
            //   title: const Text('Create Post'),
            // ),
            body: CreatePostWidget(camera: firstCamera),
          );
        }
      },
    );
  }
}