
import 'dart:convert';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      faceDetector = FaceDetector(options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true,
      ));
      isInitializing = false;
      emit(ImageCaptureStateLoaded(true, 1));
      cameraController.startImageStream((image) {
        processImage(image, frontCamera.sensorOrientation);
      });
    }
    catch (e) {
      emit(ImageCaptureStateFailure('Camera not available'));
    }
  }

  processImage (CameraImage img, int sensorOrientation) async {
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
    InputImage image = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
    detectEyePresence(image);
  }

  detectEyePresence(InputImage inputImage) async {
    final List<Face>? faces = await faceDetector?.processImage(inputImage);
    if (!isCapturing) {
      if (faces!.isEmpty) {
        emit(ImageCaptureStateInitial());
        emit(ImageCaptureStateLoaded(true, 1));
      }
      else {
        emit(ImageCaptureStateInitial());
        for (Face face in faces) {
          if (face.leftEyeOpenProbability! < 0.2 || face.rightEyeOpenProbability! < 0.2) {
            emit(ImageCaptureStateLoaded(true, 0));
          }
          else {
            emit(ImageCaptureStateLoaded(false, 1));
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
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    await cameraController.initialize();
    XFile imageFile = await cameraController.takePicture();
    InputImage eyeImage = InputImage.fromFilePath(imageFile.path);
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
    InputImage eyeImage = InputImage.fromFilePath(image.path);
    final List<Face>? faces = await faceDetector?.processImage(eyeImage);
    for (Face face in faces!) {
      final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
      await cropImage(leftEye!.position, rightEye!.position, image);
    }
  }

  Future<void> cropImage(Point<int> leftEyePosition, Point<int> rightEyePosition, XFile faceImage, {int cropWidth = 250, int cropHeight = 250}) async {
    Uint8List imageBytes = await File(faceImage.path).readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    final int? faceImageWidth = originalImage?.width;
    final int? faceImageHeight = originalImage?.height;

    final int leftX = leftEyePosition.x.clamp(0, faceImageWidth! - 1);
    final int leftY = leftEyePosition.y.clamp(0, faceImageHeight! - 1);
    final int rightX = rightEyePosition.x.clamp(0, faceImageWidth - 1);
    final int rightY = rightEyePosition.y.clamp(0, faceImageHeight - 1);

    final int leftCropX = (leftX - cropWidth ~/ 2).clamp(0, faceImageWidth - cropWidth);
    final int leftCropY = (leftY - cropHeight ~/ 2).clamp(0, faceImageHeight - cropHeight);
    final int rightCropX = (rightX - cropWidth ~/ 2).clamp(0, faceImageWidth - cropWidth);
    final int rightCropY = (rightY - cropHeight ~/ 2).clamp(0, faceImageHeight - cropHeight);

    img.Image leftCroppedImage = img.copyCrop(originalImage!, x: leftCropX, y: leftCropY, width: cropWidth, height: cropHeight);
    img.Image rightCroppedImage = img.copyCrop(originalImage, x: rightCropX, y: rightCropY, width: cropWidth, height: cropHeight);

    leftCroppedImage = img.adjustColor(leftCroppedImage, brightness: 1.0);
    rightCroppedImage = img.adjustColor(rightCroppedImage, brightness: 1.0);

    String newPathLeft = faceImage.path.replaceAll('.jpg', '_left_cropped.jpg');
    String newPathRight = faceImage.path.replaceAll('.jpg', '_right_cropped.jpg');
    File(newPathLeft).writeAsBytesSync(img.encodeJpg(leftCroppedImage));
    File(newPathRight).writeAsBytesSync(img.encodeJpg(rightCroppedImage));
    XFile leftEyeXFile = XFile(newPathLeft);
    XFile rightEyeXFile = XFile(newPathRight);

    emit(ImagesCropped(leftEyeXFile, rightEyeXFile, false, false));
    isCapturing = false;
  }

  void switchButtonLeft(XFile left, XFile right, bool leftFlag, bool rightFlag) {
    emit(ImageCaptureStateLoading());
    emit(ImagesCropped(left, right, leftFlag, rightFlag));
  }

  void switchButtonRight(XFile left, XFile right, bool leftFlag, bool rightFlag) {
    emit(ImageCaptureStateLoading());
    emit(ImagesCropped(left, right, leftFlag, rightFlag));
  }

  Future<bool> downloadFile(String path, String suggestedName) async {
    final params = SaveFileDialogParams(sourceFilePath: path, fileName: suggestedName);
    final filePath = await FlutterFileDialog.saveFile(params: params);
    if (filePath != null) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<void> uploadImageToServer(XFile leftEye, XFile rightEye) async{
    String leftEyeBase64 = await imageToBase64(leftEye);
    String rightEyeBase64 = await imageToBase64(rightEye);
    Map<String, dynamic> payload = {
      'left_eye': leftEyeBase64,
      'right_eye': rightEyeBase64,
    };
    var response = await http.post(
      Uri.parse('https://yourapi.com/upload'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
  }

  Future<String> imageToBase64(XFile file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }
}
