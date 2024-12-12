part of '../lib.dart';

class MCButtons {
  static ColorTheme theme = ColorTheme.light;

  Widget getPositiveButton(String? title, void Function()? onTap) {
    switch (theme) {
      case ColorTheme.light:
        return GestureDetector(
          child: Container(
            height: 48,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MCColors.$color_blue_40,
            ),
            child: Center(child: Text(title ?? '')),
          ),
          onTap: () => onTap,
        );
    }
  }

  Widget getNegativeButton(String? title, void Function()? onTap) {
    switch (theme) {
      case ColorTheme.light:
        return GestureDetector(
          child: Container(
            height: 48,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MCColors.$color_grey_40,
            ),
            child: Center(child: Text(title ?? '')),
          ),
          onTap: () => onTap,
        );
    }
  }
}
