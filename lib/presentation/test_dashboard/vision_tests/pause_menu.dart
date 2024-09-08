import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
                'assets/images/screen_bg.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        height: screenHeight * 0.35,
        width: screenHeight * 0.37,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: Text(
                  'You will loose your progress if you exit the game.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.black54),
                    ),
                    onPressed: onQuit,
                    child: Text(
                      ' Exit ',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.black54),
                    ),
                    onPressed: onResume,
                    child: Text(
                      'Resume',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
