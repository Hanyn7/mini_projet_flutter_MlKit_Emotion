class FaceModel {
  double? smile;
  double? rightYearsOpen;
  double? leftYearsOpen;
  String? faceDirection;
  double? leftEyeOpenProbability;
  double? rightEyeOpenProbability;
  String faceOrientation;

  FaceModel({
    this.smile,
    this.rightYearsOpen,
    this.leftYearsOpen,
    this.faceDirection,
    this.leftEyeOpenProbability,
    required this.faceOrientation,
    this.rightEyeOpenProbability,
  });
}
