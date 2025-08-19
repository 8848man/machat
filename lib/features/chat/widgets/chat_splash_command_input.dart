import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';

class SlashCommandInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color? backgroundColor;
  final String? labelText;
  final void Function(String)? onSubmitted;

  const SlashCommandInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.backgroundColor,
    this.labelText,
    this.onSubmitted,
  });

  @override
  State<SlashCommandInput> createState() => _SlashCommandInputState();
}

class _SlashCommandInputState extends State<SlashCommandInput> {
  late TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  final List<String> _commands = [
    "character:help",
    "character:Dustin",
    "character:Walt",
    "character:Geomac",
    "character:Yejin",
    "character:Mira",
    "character:Neo",
    "character:Allen",
  ];

  void _showOverlay() {
    if (_overlayEntry != null) return; // 이미 오버레이가 있으면 return
    _overlayEntry ??= OverlayEntry(
      builder: (context) {
        final text = _controller.text;
        final query = text.startsWith("/") ? text.substring(1) : "";
        final matches = query.isEmpty
            ? _commands
            : _commands
                .where((c) => c.toLowerCase().contains(query.toLowerCase()))
                .toList();

        const itemHeight = 40.0; // 리스트 아이템 하나 높이
        final totalHeight = matches.length * itemHeight;
        final offsetY = -20 - totalHeight; // TextField 위 20px + 리스트 높이만큼 위로 이동

        if (matches.isEmpty) return const SizedBox.shrink();

        return Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, offsetY), // 🔼 위로 120px 올리기
            child: McAppear(
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final cmd = matches[index];
                    return Listener(
                      behavior: HitTestBehavior.translucent, // 이벤트 전달
                      onPointerDown: (_) {
                        // 여기서 tap 처리
                        final replaced = "/$cmd ";
                        _controller
                          ..text = replaced
                          ..selection =
                              TextSelection.collapsed(offset: replaced.length);
                        _removeOverlay();
                      },
                      child: SizedBox(
                        height: itemHeight,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(text: cmd),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    if (_overlayEntry == null) {
      return;
    }
    // _focusNode.requestFocus(); // Overlay 제거 후 TextField 포커스 유지
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _focusNode = widget.focusNode;
    _controller.addListener(() {
      final text = _controller.text;
      if (text.startsWith("/")) {
        if (_overlayEntry == null) {
          _showOverlay();
        } else {
          _overlayEntry!.markNeedsBuild();
        }
      } else {
        _removeOverlay();
      }
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    // ViewModel dispose시 dispose됨
    // _controller.dispose();
    // _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MCTextInput(
        controller: _controller,
        focusNode: _focusNode,
        labelText: widget.labelText,
        backgroundColor: widget.backgroundColor,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
