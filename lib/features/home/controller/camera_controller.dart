import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraControllerExample {
  CameraController? _cameraController;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    CameraDescription? frontCamera;
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      _cameraController = CameraController(
        frontCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
    } else {
      print('No front camera found');
    }
  }

  Widget buildCameraPreview() {
    return _cameraController != null && _cameraController!.value.isInitialized
        ? CameraPreview(_cameraController!)
        : Center(child: CircularProgressIndicator());
  }

  void disposeCamera() {
    _cameraController?.dispose();
  }
}
