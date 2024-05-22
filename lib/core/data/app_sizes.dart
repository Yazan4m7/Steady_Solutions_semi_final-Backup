import 'package:flutter/material.dart';

class AppSizes extends ChangeNotifier {
  //Sizes
  double _displayWidth = 0;
  double _displayHeight = 0;

  //Paddings
  EdgeInsets _defaultPadding = EdgeInsets.zero;
  double _defaultPaddingValue = 16;
  double _paddingTop = 0;
  double _paddingBottom = 0;
  EdgeInsets _safeAreaPadding = EdgeInsets.zero;

  //fonts
  double _defaultFontSize = 14;
  double _titleFontSize = 24;
  double _bodyFontSize = 14;

  //BorderRadius
  BorderRadius _borderRadius = BorderRadius.all(Radius.circular(10));

  final BuildContext context;

  AppSizes(
    this.context,
  ) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    _displayWidth = _mediaQuery.size.width;
    _displayHeight = _mediaQuery.size.height;

    //values that depends of screen size
    if (_displayWidth >= 768) {
      //iPad Pro 9.7 pol
    } else if (_displayWidth >= 375) {
      //iPhone 11 Pro - x pol 375
      //iPhone 12 - 6.1 pol 390
    } else {
      //iPhone SE 1st Gen.
    }
    //Paddings
    _paddingTop = _mediaQuery.padding.top;
    _paddingBottom = _mediaQuery.padding.bottom;
    _safeAreaPadding =
        EdgeInsets.only(top: _paddingTop, bottom: _paddingBottom);

    _defaultPadding = EdgeInsets.all(_defaultPaddingValue);
  }
  //ScreenSize
  double get displayWidth => _displayWidth;
  double get displayHeight => _displayHeight;
  //Paddings
  EdgeInsets get defaultPadding => _defaultPadding;
  double get defaultPaddingValue => _defaultPaddingValue;
  double get paddingTop => _paddingTop;
  double get paddingBottom => _paddingBottom;
  EdgeInsets get safeAreaPadding => _safeAreaPadding;
  //fonts
  double get defaultFontSize => _defaultFontSize;
  double get titleFontSize => _titleFontSize;
  double get bodyFontSize => _bodyFontSize;
  //BorderRadius
  BorderRadius get defaultBorderRadius => _borderRadius;
}
