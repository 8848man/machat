import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget get center => Center(child: this);

  Widget get sizedBoxExpand => SizedBox.expand(child: this);

  /// 1:1 사이즈로 aspectRatio 반영
  Widget get square => AspectRatio(
        aspectRatio: 1,
        child: this,
      );

  Widget get positionedZero => Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: this,
      );

  /// [opacity] 0.0 ~ 1.0
  Widget opacity(double opacity) => Opacity(
        opacity: opacity,
        child: this,
      );

  Widget margin({required EdgeInsets margin}) => Container(
        margin: margin,
        child: this,
      );

  Widget sizedBox({double? width, double? height}) => SizedBox(
        width: width,
        height: height,
        child: this,
      );

  Widget padding({required EdgeInsets padding}) => Padding(
        padding: padding,
        child: this,
      );

  Widget align({required Alignment alignment}) => Align(
        alignment: alignment,
        child: this,
      );

  Widget flex({int flex = 1}) => Flexible(
        flex: flex,
        child: this,
      );

  Widget expand({int flex = 1}) => Expanded(
        child: this,
        flex: flex,
      );

  Widget scroll({
    ScrollController? controller,
    EdgeInsets? padding,
  }) =>
      SingleChildScrollView(
        controller: controller,
        padding: padding,
        child: this,
      );

  Widget aspectRatio({required double aspectRatio}) => AspectRatio(
        aspectRatio: aspectRatio,
        child: this,
      );

  /// [condition] 인자에 조건을 넣어, true 인 경우 elseWidget 으로 출력
  Widget or(bool condition, {Widget elseWidget = const Align()}) {
    if (condition) return elseWidget;
    return this;
  }
}

extension AnimationExtensions on AnimationController {
  void repeatReverseEx({required int times}) {
    int count = 0;
    forward();

    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (++count <= times) reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (count < times) forward();
      }
    });
  }
}
