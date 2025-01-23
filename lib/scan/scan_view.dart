import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
    if (status.isGranted) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      final firstCamera = cameras.first;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        body: const Center(
          child: Text(
            'Camera permission is required', 
            style: TextStyle(color: Colors.white)
          )
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 41, 41),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'Scan Receipt',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade300,
                  shadows: [
                    Shadow(
                      color: Colors.blue.shade300,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: _controller == null || _initializeControllerFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}


