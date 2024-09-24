import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ImageZoom extends StatelessWidget {
  const ImageZoom(
      {super.key,
        this.showCloseButton = true,
        this.showButton = true,
        this.needToPop = true});
  final bool showCloseButton;
  final bool showButton;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width * 0.75,
        height: MediaQuery.sizeOf(context).height * 0.4,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: constraints.maxWidth,
                alignment: Alignment.centerRight,
                height: 30,
                child: showCloseButton
                    ? GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                    size: 30,
                  ),
                )
                    : null,
              ),

            ],
          );
        }),
      ),
    );
  }
}