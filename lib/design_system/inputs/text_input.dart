part of '../lib.dart';

class MCTextInput extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final Widget? error;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final Color? backgroundColor;
  final bool? isObscure;

  const MCTextInput({
    super.key,
    this.labelText,
    this.errorText,
    this.error,
    this.onChanged,
    this.focusNode,
    required this.controller,
    this.backgroundColor,
    this.onSubmitted,
    this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        color: backgroundColor ?? backgroundColor,
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          errorText: errorText,
          error: error,
          // fillColor: Colors.white,
        ),
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        obscureText: isObscure ?? false,
      ),
    );
  }
}
