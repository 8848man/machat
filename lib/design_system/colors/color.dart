part of '../lib.dart';

//테마 확장성
enum ColorTheme {
  light,
}

class MCColors {
  static ColorTheme theme = ColorTheme.light;

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  ///ex)) gradient_color
  static LinearGradient get button_gradient {
    switch (theme) {
      case ColorTheme.light:
        return const LinearGradient(
          stops: [0.0, 1.0],
          end: Alignment(-0.2, -0.2),
          begin: Alignment(1.2, 1.2),
          transform: GradientRotation(3),
          colors: [
            Color.fromRGBO(255, 255, 255, 0.3),
            Color.fromRGBO(204, 96, 255, 0.7)
          ],
        );
    }
  }

  // 브랜드컬러, 빨간색
  static Color get $color_brand {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_100;
    }
  }

  // 사이드바 배경색
  static Color get $sidebar_background {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFFFFF');
    }
  }

  // 사이드바 우측 화면 기본 배경 컬러
  static Color get $default_bgcolor {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#E6E6E6');
    }
  }

  /// grey_scale
  static Color get $color_grey_100 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#131416');
    }
  }

  static Color get $color_grey_90 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#2B2C2E');
    }
  }

  static Color get $color_grey_80 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#424345');
    }
  }

  static Color get $color_grey_70 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#5A5B5C');
    }
  }

  static Color get $color_grey_60 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#717273');
    }
  }

  static Color get $color_grey_50 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#88898A');
    }
  }

  static Color get $color_grey_40 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#A1A1A2');
    }
  }

  static Color get $color_grey_30 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#B9B9BA');
    }
  }

  static Color get $color_grey_20 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#D0D0D0');
    }
  }

  static Color get $color_grey_10 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#E8E8E8');
    }
  }

  // 태블릿 기본 배경색
  static Color get $color_grey_05 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#F3F3F3');
    }
  }

  static Color get $color_grey_02 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FAFAFA');
    }
  }

  // 진한 배경색 위의 글자색
  static Color get $color_grey_00 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFFFFF');
    }
  }

  /// grey_scale

  /// color_scale

  // blue

  static Color get $color_blue_100 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0043A8');
    }
  }

  static Color get $color_blue_90 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#004DC2');
    }
  }

  static Color get $color_blue_80 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0058DB');
    }
  }

  static Color get $color_blue_70 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0062F5');
    }
  }

  static Color get $color_blue_60 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0F6FFF');
    }
  }

  static Color get $color_blue_50 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#2B7FFF');
    }
  }

  static Color get $color_blue_40 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#428EFF');
    }
  }

  static Color get $color_blue_30 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#5C9DFF');
    }
  }

  static Color get $color_blue_20 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#75ACFF');
    }
  }

  static Color get $color_blue_10 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#8FBCFF');
    }
  }

  //blue

  //red

  static Color get $color_red_100 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#2C0000');
    }
  }

  static Color get $color_red_90 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#DB0000');
    }
  }

  static Color get $color_red_80 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#F50000');
    }
  }

  static Color get $color_red_70 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF0F0F');
    }
  }

  static Color get $color_red_60 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF2929');
    }
  }

  static Color get $color_red_50 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF4545');
    }
  }

  static Color get $color_red_40 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF5C5C');
    }
  }

  static Color get $color_red_30 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF7575');
    }
  }

  static Color get $color_red_20 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF8F8F');
    }
  }

  static Color get $color_red_10 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFA8A8');
    }
  }

  //red

  //orange

  static Color get $color_orange_100 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#A84700');
    }
  }

  static Color get $color_orange_90 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#C25100');
    }
  }

  static Color get $color_orange_80 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#DB5C00');
    }
  }

  static Color get $color_orange_70 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#F56700');
    }
  }

  static Color get $color_orange_60 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF740F');
    }
  }

  static Color get $color_orange_50 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF8126');
    }
  }

  static Color get $color_orange_40 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FF9242');
    }
  }

  static Color get $color_orange_30 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFA05C');
    }
  }

  static Color get $color_orange_20 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFAF75');
    }
  }

  static Color get $color_orange_10 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#FFBE8F');
    }
  }
  //orange

  //green

  static Color get $color_green_100 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#095D21');
    }
  }

  static Color get $color_green_90 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0C7429');
    }
  }

  static Color get $color_green_80 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#0E8B31');
    }
  }

  static Color get $color_green_70 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#10A239');
    }
  }

  static Color get $color_green_60 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#13B941');
    }
  }

  static Color get $color_green_50 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#15D04A');
    }
  }

  static Color get $color_green_40 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#17E852');
    }
  }

  static Color get $color_green_30 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#2FEA63');
    }
  }

  static Color get $color_green_20 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#46EC74');
    }
  }

  static Color get $color_green_10 {
    switch (theme) {
      case ColorTheme.light:
        return _fromHex('#5DEF86');
    }
  }
  //green

  /// color_scale

  /// system_color
  static Color get $color_primary {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_100;
    }
  }

  static Color get $color_hover {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_50;
    }
  }

  static Color get $color_focused {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_80;
    }
  }

  static Color get $color_disabled {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_10;
    }
  }

  static Color get $color_negative {
    switch (theme) {
      case ColorTheme.light:
        return $color_red_50;
    }
  }

  static Color get $color_positive {
    switch (theme) {
      case ColorTheme.light:
        return $color_blue_50;
    }
  }

  static Color get $color_sidebar_icon_unselected {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_60;
    }
  }

  static Color get $color_sidebar_icon_selected {
    switch (theme) {
      case ColorTheme.light:
        return $color_grey_00;
    }
  }

  /// system_color
}
