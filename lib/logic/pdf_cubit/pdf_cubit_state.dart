import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

abstract class PDFState {}

class PDFLoading extends PDFState {}

class PDFInitial extends PDFState {}

class PDFLoaded extends PDFState {
  late final List<dynamic> items;
  final Completer<PDFViewController> controller;
  PDFLoaded(this.items, this.controller);
}

class PDFError extends PDFState {
  final String message;

  PDFError(this.message);
}

class PDFCubit extends Cubit<PDFState> {
  PDFCubit() : super(PDFInitial()) {
    fetchAndInitializePDFList();
  }

  String pathPDF = '';

  void fetchAndInitializePDFList() async {
    emit(PDFLoading());
    try {
      final items = [];
      await fromAsset('assets/pdfs/ocula_pdf.pdf', 'ocula_pdf.pdf')
          .then((f) {
        items.add(f.path);
      });
      final controller = Completer<PDFViewController>();

      emit(PDFLoaded(items, controller));
    } catch (e) {
      emit(PDFError('Failed to load shopping list: $e'));
    }
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
}
