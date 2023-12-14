import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:mini_p/features/home/module/face_model.dart';

class FaceDetectionController {
  FaceDetector? _faceDetector;

  Future<List<FaceModel>?> processImage(InputImage inputImage) async {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );

    final faces = await _faceDetector?.processImage(inputImage);
    return extractFaceInfo(faces);
  }

  List<FaceModel>? extractFaceInfo(List<Face>? faces) {
    List<FaceModel>? response = [];
    for (Face face in faces!) {
      final faceModel = FaceModel(
        smile: face.smilingProbability,
        leftEyeOpenProbability: face.leftEyeOpenProbability,
        rightEyeOpenProbability: face.rightEyeOpenProbability,
        faceOrientation: detectFaceOrientation(face),
      );
      response.add(faceModel);
    }
    return response;
  }

  String detectFaceOrientation(Face face) {
    double? leftEyeX =
        face.getContour(FaceContourType.leftEye)?.positionsList.first.dx;
    double? rightEyeX =
        face.getContour(FaceContourType.rightEye)?.positionsList.first.dx;

    if (leftEyeX != null && rightEyeX != null) {
      double distance = rightEyeX - leftEyeX;
      if (distance > 10) {
        return 'Right'; 
      } else if (distance < -15.0) {
        return 'Left'; 
      }
    }
    return 'Front'; 
  }
}
