import 'dart:convert';

import 'package:cculacare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../configs/app/notification/notification_service.dart';
import '../../configs/global/app_globals.dart';
import '../../data/models/disease_result/disease_result_model.dart';
import 'img_capture_state.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class ImageCaptureCubit extends Cubit<ImageCaptureState> {
  ImageCaptureCubit() : super(ImageCaptureStateInitial());

  late CameraController cameraController;
  XFile? imageFile;
  bool isInitializing = false;
  late List<CameraDescription> _cameras;
  FaceDetector? faceDetector;
  List<Face>? facesList;
  bool isProcessing = false;
  bool isCapturing = false;

  Future<void> dispose() async {
    cameraController.stopImageStream();
    isProcessing = false;
    emit(ImageCaptureStateInitial());
    cameraController.dispose();
    faceDetector?.close();
  }

  Future<void> initializeCamera() async {
    emit(ImageCaptureStateLoading());
    isInitializing = true;
    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
        enableAudio: false,
      );
      await cameraController.initialize();
      await cameraController.setFlashMode(FlashMode.off);
      await cameraController.setFocusMode(FocusMode.auto);
      faceDetector = FaceDetector(
          options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: true,
            enableClassification: true,
      ));
      isInitializing = false;
      emit(ImageCaptureStateLoaded(true, 1));
      cameraController.startImageStream((image) {
        processImage(image, frontCamera.sensorOrientation);
      });
    } catch (e) {
      emit(ImageCaptureStateFailure('Camera not available'));
    }
  }

  processImage(CameraImage img, int sensorOrientation) async {
    if (isProcessing) return;
    isProcessing = true;
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in img.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final imageSize = Size(img.width.toDouble(), img.height.toDouble());
    final imageRotation = _getRotation(sensorOrientation);
    const inputImageFormat = InputImageFormat.yuv420;
    final planeData = img.planes.first.bytesPerRow;
    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: planeData,
    );
    InputImage image =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
    detectEyePresence(image);
  }

  detectEyePresence(InputImage inputImage) async {
    final List<Face>? faces = await faceDetector?.processImage(inputImage);
    if (!isCapturing) {
      if (faces!.isEmpty) {
        emit(ImageCaptureStateInitial());
        emit(ImageCaptureStateLoaded(true, 1));
      } else {
        emit(ImageCaptureStateInitial());
        for (Face face in faces) {
          if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
            if (face.leftEyeOpenProbability! < 0.2 ||
                face.rightEyeOpenProbability! < 0.2) {
              print('hhhhhhkkkkkkk');
              emit(ImageCaptureStateLoaded(true, 0));
            } else {
              print('hhhhhh');
              emit(ImageCaptureStateLoaded(false, 1));
            }
          }
        }
      }
    }
    isProcessing = false;
  }

  InputImageRotation _getRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  void captureEyeImage() async {
    isCapturing = true;
    emit(ImageCaptureStateLoading());
    await cameraController.stopImageStream();
    await cameraController.dispose();
    _cameras = await availableCameras();
    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );
    cameraController = CameraController(
      frontCamera,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    await cameraController.initialize();
    XFile imageFile = await cameraController.takePicture();
    InputImage eyeImage = InputImage.fromFilePath(imageFile.path);
    faceImage = eyeImage;
    final List<Face>? faces = await faceDetector?.processImage(eyeImage);
    for (Face face in faces!) {
      final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
      await cropImage(leftEye!.position, rightEye!.position, imageFile);
    }
  }

  void uploadEyeImage(XFile image) async {
    isCapturing = true;
    cameraController.stopImageStream();
    emit(ImageCaptureStateLoading());

    try {
      InputImage eyeImage = InputImage.fromFilePath(image.path);
      faceImage = eyeImage;
      bool faceDetected = false;
      //  Future.delayed(const Duration(seconds: 10), () async {
      //   if (!faceDetected) {
      //     emit(ImageCaptureStateFailure('No face detected within 10 seconds.'));
      //   }
      // });

      final List<Face>? faces = await faceDetector?.processImage(eyeImage);

      if (faces != null && faces.isNotEmpty) {
        faceDetected = true;
        for (Face face in faces) {
          final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
          final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];

          if (leftEye != null && rightEye != null) {
            await cropImage(leftEye.position, rightEye.position, image);
          } else {
            isCapturing = false;
            emit(ImageCaptureStateFailure('Could not detect both eyes.'));
          }
        }
      } else {
        isCapturing = false;
        emit(ImageCaptureStateFailure('No face detected.'));
      }
    } catch (e) {
      isCapturing = false;
      emit(ImageCaptureStateFailure('Error processing image.'));
    }
  }

  Future<XFile?> cropImageWithBoundingBox(
      Point<int> leftEyePosition, Point<int> rightEyePosition, XFile faceImage,
      {int padding = 80, int extraPaddingSides = 20}) async {
    Uint8List imageBytes = await File(faceImage.path).readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) return null;

    final int faceImageWidth = originalImage.width;
    final int faceImageHeight = originalImage.height;

    final int leftX = leftEyePosition.x.clamp(0, faceImageWidth - 1);
    final int leftY = leftEyePosition.y.clamp(0, faceImageHeight - 1);
    final int rightX = rightEyePosition.x.clamp(0, faceImageWidth - 1);
    final int rightY = rightEyePosition.y.clamp(0, faceImageHeight - 1);

    final int boundingBoxX = (leftX - padding - extraPaddingSides).clamp(0, faceImageWidth - 1);
    final int boundingBoxY = (min(leftY, rightY) - padding).clamp(0, faceImageHeight - 1);

    final int boundingBoxWidth = (rightX - leftX + 2 * padding + 2 * extraPaddingSides).clamp(0, faceImageWidth - boundingBoxX);

    final int boundingBoxHeight = ((max(leftY, rightY) as int) - (min(leftY, rightY) as int) + 2 * padding).clamp(0, faceImageHeight - boundingBoxY);

    img.Image croppedImage = img.copyCrop(
      originalImage,
      x: boundingBoxX,
      y: boundingBoxY,
      width: boundingBoxWidth,
      height: boundingBoxHeight,
    );

    croppedImage = img.adjustColor(croppedImage, brightness: 1.0);

    String newPath = faceImage.path.replaceAll('.jpg', '_bounding_box_cropped.jpg');
    File(newPath).writeAsBytesSync(img.encodeJpg(croppedImage));

    XFile boundingBoxCroppedXFile = XFile(newPath);
    isCapturing = false;
    return boundingBoxCroppedXFile;
  }




  Future<void> cropImage(
      Point<int> leftEyePosition, Point<int> rightEyePosition, XFile faceImage,
      {int cropWidth = 250, int cropHeight = 250}) async {
    Uint8List imageBytes = await File(faceImage.path).readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    final int? faceImageWidth = originalImage?.width;
    final int? faceImageHeight = originalImage?.height;

    final int leftX = leftEyePosition.x.clamp(0, faceImageWidth! - 1);
    final int leftY = leftEyePosition.y.clamp(0, faceImageHeight! - 1);
    final int rightX = rightEyePosition.x.clamp(0, faceImageWidth - 1);
    final int rightY = rightEyePosition.y.clamp(0, faceImageHeight - 1);

    final int leftCropX =
        (leftX - cropWidth ~/ 2).clamp(0, faceImageWidth - cropWidth);
    final int leftCropY =
        (leftY - cropHeight ~/ 2).clamp(0, faceImageHeight - cropHeight);
    final int rightCropX =
        (rightX - cropWidth ~/ 2).clamp(0, faceImageWidth - cropWidth);
    final int rightCropY =
        (rightY - cropHeight ~/ 2).clamp(0, faceImageHeight - cropHeight);

    img.Image leftCroppedImage = img.copyCrop(originalImage!,
        x: leftCropX, y: leftCropY, width: cropWidth, height: cropHeight);
    img.Image rightCroppedImage = img.copyCrop(originalImage,
        x: rightCropX, y: rightCropY, width: cropWidth, height: cropHeight);

    leftCroppedImage = img.adjustColor(leftCroppedImage, brightness: 1.0);
    rightCroppedImage = img.adjustColor(rightCroppedImage, brightness: 1.0);

    String newPathLeft = faceImage.path.replaceAll('.jpg', '_left_cropped.jpg');
    String newPathRight =
        faceImage.path.replaceAll('.jpg', '_right_cropped.jpg');
    File(newPathLeft).writeAsBytesSync(img.encodeJpg(leftCroppedImage));
    File(newPathRight).writeAsBytesSync(img.encodeJpg(rightCroppedImage));
    XFile leftEyeXFile = XFile(newPathLeft);
    XFile rightEyeXFile = XFile(newPathRight);
    XFile? fullFace = await cropImageWithBoundingBox(leftEyePosition, rightEyePosition, faceImage);
    if (fullFace != null) {
      emit(ImagesCropped(
        leftEyeXFile,
        rightEyeXFile,
        fullFace,
      ));
    }
    else {
      emit(ImageCaptureStateFailure('Could not detect both eyes.'));
    }
    isCapturing = false;
  }

  Future<bool> downloadFile(String path, String suggestedName) async {
    final params =
        SaveFileDialogParams(sourceFilePath: path, fileName: suggestedName);
    final filePath = await FlutterFileDialog.saveFile(params: params);
    if (filePath != null) {
      return true;
    } else {
      return false;
    }
  }

  String getCurrentDateString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  Future<void> uploadImageToServer(XFile leftEye, XFile rightEye, XFile fullFace, String modelFlag) async {
    String leftEyeBase64 = await imageToBase64(leftEye);
    String rightEyeBase64 = await imageToBase64(rightEye);
    String fullBase64 = await imageToBase64(fullFace);
    final date = getCurrentDateString();
    Map<String, dynamic> payload = {
      'left_eye': leftEyeBase64,
      'right_eye': rightEyeBase64,
      'date': date,
      'bulgy_eye': fullBase64,
      'patient_name':  sharedPrefs.userName,
      'email': sharedPrefs.email,
      'flag': modelFlag,
    };
    try {
      var response = await http.post(
        Uri.parse('http://192.168.18.74:8000/predict'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        DiseaseResultModel result = DiseaseResultModel.fromJson(data);
        globalResults.add(result);
        NotificationService.resultReadyNotification('Disease Analysis', 'Analysis report is ready', DateTime.now().add(const Duration(seconds: 2)));
      } else {
        debugPrint("Nothing ${response.body}");
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<bool> detectStrabismusWithFullAlignment(InputImage inputImage) async {
    final List<Face> faces = await faceDetector!.processImage(inputImage);
    if (faces.isNotEmpty) {
      final face = faces.first;
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];

      if (leftEye != null && rightEye != null) {
        // Get positions of the left and right eyes
        final int leftEyeX = leftEye.position.x;
        final int leftEyeY = leftEye.position.y;
        final int rightEyeX = rightEye.position.x;
        final int rightEyeY = rightEye.position.y;

        // Calculate padding for top and bottom lines
        const double padding = 20.0;

        // Line through the center of both eyes (middle line)
        final double midLineY = (leftEyeY + rightEyeY) / 2;

        // Top and bottom lines
        final double topLineY = midLineY - padding;
        final double bottomLineY = midLineY + padding;

        // Horizontal alignment check: difference in X-axis between eyes
        final double horizontalThreshold = 50.0;  // You can adjust this threshold
        final int eyeDistance = (rightEyeX - leftEyeX);

        // Ideal eye distance based on facial structure (modify based on dataset)
        final double idealEyeDistance = 50.0;  // You may adjust this value

        // Check if eyes are aligned vertically and horizontally
        bool isLeftEyeAlignedVertically = (leftEyeY >= topLineY) && (leftEyeY <= bottomLineY);
        bool isRightEyeAlignedVertically = (rightEyeY >= topLineY) && (rightEyeY <= bottomLineY);

        // Horizontal check: eye distance should be within the threshold
        bool isEyesAlignedHorizontally = (eyeDistance >= idealEyeDistance - horizontalThreshold) &&
            (eyeDistance <= idealEyeDistance + horizontalThreshold);

        // Detect strabismus if either eye deviates vertically or horizontally
        if (!isLeftEyeAlignedVertically || !isRightEyeAlignedVertically || !isEyesAlignedHorizontally) {
          return true; // Strabismus detected
        } else {
          return false; // No Strabismus
        }
      }
    }
    return false;
  }



  Future<bool> detectStrabismusPresence(InputImage inputImage) async {
    final List<Face> faces = await faceDetector!.processImage(inputImage);
    if (faces.isNotEmpty) {
      final face = faces.first;
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];
      final noseBase = face.landmarks[FaceLandmarkType.noseBase];

      if (leftEye != null && rightEye != null && noseBase != null) {
        double leftEyeToNoseDistance = calculateDistance(
          leftEye.position.x, leftEye.position.y,
          noseBase.position.x, noseBase.position.y,
        );

        double rightEyeToNoseDistance = calculateDistance(
          rightEye.position.x, rightEye.position.y,
          noseBase.position.x, noseBase.position.y,
        );

        bool isStrabismus = detectCrossedEyes(leftEyeToNoseDistance, rightEyeToNoseDistance);

        return isStrabismus;
      }
    }
    return false;
  }

  double calculateDistance(int x1, int y1, int x2, int y2) {
    return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
  }

  bool detectCrossedEyes(double leftEyeToNose, double rightEyeToNose) {
    const double threshold = 5.0;
    double res = (leftEyeToNose - rightEyeToNose).abs();
    print(res);
    return res > threshold;
  }

  Future<String> imageToBase64(XFile file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }
}
