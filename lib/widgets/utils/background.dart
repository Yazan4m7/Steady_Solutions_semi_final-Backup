import 'package:flutter/material.dart';

import '../../app_config/app_theme.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  final String bottomImage;

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 10,
              left: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/backgrounds/mockup6.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [
                            0.4,
                            0.9,
                          ],
                          colors: [
                            grey_bg_color.withOpacity(0.8),
                            grey_bg_color
                            ,
                            // Adjust opacity as needed
                          ],
                        ),
                      ),
                      child: child)),
            ),
      
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Image.asset(bottomImage, width: 120),
            // ),
          ],
        ),
    );
    
  }
}
