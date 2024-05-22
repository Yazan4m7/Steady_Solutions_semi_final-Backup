import 'package:flutter/material.dart';
import 'package:steady_solutions/core/data/app_sizes.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  Responsive({
    Key? key,
    required this.tablet,
    required this.mobile,
    required this.desktop,
  }) : super(key: key) {
   
  }

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
   static int getResponsiveGridCrossAxis(BuildContext context){
    AppSizes sizes = AppSizes(context);
    int crossAxis = 2;
    if (Responsive.isMobile(context)) {
      crossAxis = sizes.displayWidth < 650 ? 2 : 4;
    } else if (Responsive.isTablet(context)) {
      crossAxis = 4;
    } else if (Responsive.isDesktop(context)) {
      crossAxis = sizes.displayWidth < 1400 ? 1 : 2;
    }
    return crossAxis;

  }
   static double getResponsiveAspectRatio(BuildContext context){
    AppSizes sizes = AppSizes(context);
    double aspectRatio = 2;
    if (Responsive.isMobile(context)) {
      aspectRatio = sizes.displayWidth < 650 ? 1.6 : 1;
    } else if (Responsive.isTablet(context)) {
      aspectRatio = 1;
    } else if (Responsive.isDesktop(context)) {
      aspectRatio = sizes.displayWidth < 1400 ? 1.1 : 1.4;
    }
    return aspectRatio;

  }
}