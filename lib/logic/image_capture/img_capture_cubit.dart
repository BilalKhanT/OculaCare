





import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocula_care/configs/utils/utils,dart.dart';
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

  Future<void> dispose() async {
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
        // final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
        // final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
        // if (leftEye != null && rightEye != null) {
        //   emit(ImageCaptureStateLoaded(false));
        // }
        // else {
        //   emit(ImageCaptureStateLoaded(true));
        // }
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
}
