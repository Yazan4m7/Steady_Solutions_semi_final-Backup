import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

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
    return Scaffold(
      
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      body: Stack(
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
                  
                      image: AssetImage("assets/images/backgrounds/mockup4.png"),
                      fit: BoxFit.cover,
                   
                 
                ),
              ),
              child: BackdropFilter(
                filter:ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: child)
            ),
           
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
