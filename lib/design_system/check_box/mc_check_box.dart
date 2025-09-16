part of '../lib.dart';

class MCCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final Color? color;
  final double? scale; // 배율로 체크박스 사이즈 정함

  const MCCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.color,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.focused,
        WidgetState.selected,
      };
      if (states.any(interactiveStates.contains)) {
        return color ?? Colors.blue;
      }
      return Colors.white;
    }

    return Transform.scale(
      scale: scale ?? 1, // 1.0 = 기본, 1.5 = 150%
      child: SizedBox(
        height: 24.toDouble() * (scale ?? 1),
        width: 24.toDouble() * (scale ?? 1),
        child: Checkbox(
          checkColor: Colors.white,
          fillColor: WidgetStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
