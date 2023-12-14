import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:camera/camera.dart';
import 'package:mini_p/features/home/controller/face_detention_controller.dart';
import 'package:mini_p/features/home/module/face_model.dart';

class HomeController extends GetxController {
  CameraController? cameraController;
  FaceDetectionController? faceDetectionController;
  bool _isDetecting = false;
  List<FaceModel>? faces;
  String? label = 'Normal';
  String? animationPath = 'images/no_face.json';

  HomeController() {
    faceDetectionController = FaceDetectionController();
  }

  Future<void> loadCamera() async {
    final cameras = await availableCameras();

    CameraDescription? frontCamera;
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera != null) {
      cameraController = CameraController(frontCamera, ResolutionPreset.medium);
      await cameraController?.initialize();
      await startImageStream();
      update();
    } else {
      print('No front camera found');
    }
  }

  Future<void> startImageStream() async {
    cameraController?.startImageStream((CameraImage cameraImage) async {
      if (_isDetecting) return;

      _isDetecting = true;

      final Size imageSize = Size(
        cameraImage.width.toDouble(),
        cameraImage.height.toDouble(),
      );

      final planeData = cameraImage.planes.map((Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      }).toList();

      final List<Uint8List> allBytes =
          cameraImage.planes.map((Plane plane) => plane.bytes).toList();
      final Uint8List bytes = Uint8List.fromList(
        allBytes.expand((element) => element).toList(),
      );

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: InputImageRotationMethods.fromRawValue(
                cameraController?.description.sensorOrientation ?? 0) ??
            InputImageRotation.Rotation_0deg,
        inputImageFormat:
            InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
                InputImageFormat.NV21,
        planeData: planeData,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );

      await processImage(inputImage);
    });
  }

  Future<void> processImage(InputImage inputImage) async {
    animationPath = 'images/no_face.json';

    faces = await faceDetectionController?.processImage(inputImage);

    if (faces != null && faces!.isNotEmpty) {
      FaceModel? face = faces?.first;
      label = detectSmile(face?.smile);
    } else {
      label = 'No face detected';
    }

    _isDetecting = false;
    update();
  }

  String detectSmile(double? smileProb) {
    if (smileProb != null) {
      if (smileProb > 0.86) {
        animationPath = 'images/happy.json';
        return 'Big smile with teeth';
      } else if (smileProb > 0.35) {
        animationPath = 'images/happy.json';
        return 'Smile';
      }
    }
    animationPath = 'images/sad.json';
    return 'Sad';
  }

  Widget getLottieAnimationWidget(Size previewSize) {
    return SizedBox(
      width:
          previewSize.width, // Set the width to match the camera preview zone
      height:
          previewSize.height, // Set the height to match the camera preview zone
      child: FittedBox(
        fit: BoxFit.cover,
        child: Lottie.asset(
          animationPath!,
          width: 200, // Adjust the animation's original width if needed
          height: 200, // Adjust the animation's original height if needed
        ),
      ),
    );
  }
}
