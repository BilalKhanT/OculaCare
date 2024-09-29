import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MedicineView extends StatelessWidget {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                      height: screenHeight * 0.5,
                      width: screenWidth,
                child: const WebView(
                  initialUrl: 'https://app.vectary.com/p/4pWRcBqOMjR8vy33R2Tf68',
                  javascriptMode: JavascriptMode.unrestricted,

                ),
                    ),
            ],
          )),
    );
  }
}
