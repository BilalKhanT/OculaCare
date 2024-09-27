import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import '../../logic/pdf_cubit/pdf_cubit_state.dart';

// ignore: must_be_immutable
class PDFViewScreen extends StatelessWidget {
  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";
  PDFViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          "Leaflets",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.appColor,),
        ),
      ),
      body: BlocBuilder<PDFCubit, PDFState>(builder: (context, state) {
        if (state is PDFLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is PDFLoaded) {
          return PDFView(
            filePath: state.items[0],
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: 0,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            onRender: (pages) {},
            onError: (error) {
              if (kDebugMode) {
                print(error.toString());
              }
            },
            onPageError: (page, error) {},
            onViewCreated: (PDFViewController pdfViewController) {
              state.controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {},
            onPageChanged: (int? page, int? total) {},
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
