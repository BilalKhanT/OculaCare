import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  late CameraController camera;
  late List<CameraDescription> cameras;
  FaceDetector? faceDetector;
  List<Face>? facesList;
  bool isProcessing = false;

  Future<void> disposeCamera() async {
    await camera.stopImageStream();
    await camera.dispose();
    await faceDetector?.close();
  }

  Future<void> initializeCamera() async {
    emit(CameraLoading());
    try {
      cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      camera = CameraController(
        frontCamera,
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
        enableAudio: false,
      );
      await camera.initialize();
      await camera.setFlashMode(FlashMode.off);
      await camera.setFocusMode(FocusMode.auto);
      faceDetector = FaceDetector(
          options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true,
      ));
      emit(CameraLoaded(camera, 'Checking'));
      camera.startImageStream((image) {
        processImage(image, frontCamera.sensorOrientation);
      });
    } catch (e) {
      log(e.toString());
      emit(const CameraError('Failed to load camera'));
    }
  }

  Future<void> processImage(CameraImage img, int sensorOrientation) async {
    if (isProcessing == true) {
      return;
    }
    isProcessing = true;
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in img.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final imageSize = Size(img.width.toDouble(), img.height.toDouble());
    final imageRotation = getRotation(sensorOrientation);
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

    final faces = await faceDetector?.processImage(image);

    if (faces!.isNotEmpty) {
      final face = faces.first;
      final faceWidth = face.boundingBox.width;
      calculateDistance(faceWidth, img.width,);
    }
    isProcessing = false;
  }

  InputImageRotation getRotation(int sensorOrientation) {
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

  void calculateDistance(double faceWidthPx, int imageWidthPx) {
    const double sensorWidthMm = 6.4;
    const double focalLengthMm = 4.15;
    const double knownFaceWidthMm = 160.0;

    final double faceWidthRatio = faceWidthPx / imageWidthPx;
    final double distanceMm = (knownFaceWidthMm * focalLengthMm) / (faceWidthRatio * sensorWidthMm);

    final double distanceMeters = distanceMm / 1000;

    if (distanceMeters >= 0.3 && distanceMeters <= 0.4) {
      emit(CameraSuccess());
    }
    else if (distanceMeters < 0.3) {
      emit(CameraInitial());
      emit(CameraLoaded(camera, 'Move phone away'));
    }
    else if (distanceMeters > 0.4) {
      emit(CameraInitial());
      emit(CameraLoaded(camera, 'Bring phone closer'));
    }
  }
}
