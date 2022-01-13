// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:pomodoro/responsive/sizing_info.dart';
import 'edge_insets_app.dart';

class ResponsiveApp {
  final BuildContext _context;
  late MediaQueryData _mediaQueryData;
  late double _textScaleFactor;
  late double _scaleFactor;
  late EdgeInsetsApp edgeInsetsApp;
  ResponsiveApp(this._context){
    _mediaQueryData = MediaQuery.of(_context);
    _textScaleFactor = _mediaQueryData.textScaleFactor;
    _scaleFactor = isMobile(_context)? 1 :isTablet(_context)?1.1:1.3;
    edgeInsetsApp= EdgeInsetsApp(this);
  }

  //Container
  get menuContainerHeight=>setHeight(100);
  get menuContainerWidth=>setWidth(110);
  get productContainerWidth=>setWidth(60);
  get carouselContainerWidth=>setWidth(300);
  get carouselContainerHeight=>setHeight(60);
  get carouselCircleContainerWidth=>setWidth(10);
  get carouselCircleContainerHeight=>setHeight(10);
  get menuTabContainerHeight=>setHeight(400);
  get sectionHeight=>setHeight(50);
  get sectionWidth=>setWidth(8);

  //Radius
  get menuRadiusWidth=>setWidth(30);
  get carouselRadiusWidth=>setWidth(10);


  //Images
  get menuImageHeight=>setHeight(60);
  get menuImageWidth=>setWidth(50);
  get tabImageHeight=>setHeight(30);

  get menuHeight=>setHeight(850);
  get opacityHeight=>setHeight(252);
  get drawerWidth=>setWidth(252);

  //Divider and Line
  get dividerVtlHeight=>setHeight(100);
  get dividerVtlWidth=>setWidth(2);
  get dividerHznHeight=>setHeight(1);
  get lineHznButtonHeight=>setHeight(2);
  get lineHznButtonWidth=>setWidth(20);
  //Spaces
  get barSpace1Width=>setWidth(60);
  get barSpace2Width=>setWidth(80);

  //Text Size
  get bodyText1=>setSp(24);
  get headline3=>setSp(34);
  get headline2=>setSp(40);
  get headline1=>setSp(52);

  //Spacing
  get letterSpacingCarouselWidth=>setWidth(10);
  get letterSpacingHeaderWidth=>setWidth(3);

  //Forms
  get widthForm => setWidth(125);

  setWidth(int width) => width * _scaleWidth;

  setHeight(int height) => height * _scaleHeight;

  setSp(int fontSize) =>
      setWidth(fontSize) * _textScaleFactor;

  get _scaleWidth => (width * _scaleFactor) / width;

  get _scaleHeight => (height * _scaleFactor) /height;

  get width =>_mediaQueryData.size.width;
  get height =>_mediaQueryData.size.height;
}