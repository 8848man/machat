part of '../lib.dart';

class MCTextInput extends StatelessWidget {
  final String? labelText;
  final String? errorText;
  final Widget? error;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextEditingController controller;

  const MCTextInput({
    super.key,
    this.labelText,
    this.errorText,
    this.error,
    this.onChanged,
    this.focusNode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        errorText: errorText,
        error: error,
      ),
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
    );
  }
}
