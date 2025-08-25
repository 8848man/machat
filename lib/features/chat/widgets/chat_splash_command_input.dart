import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat/utils/command_setter.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

class SlashCommandInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color? backgroundColor;
  final String? labelText;
  final void Function(String)? onSubmitted;
  final int? showCommandsCount;

  const SlashCommandInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.backgroundColor,
    this.labelText,
    this.onSubmitted,
    this.showCommandsCount,
  });

  @override
  State<SlashCommandInput> createState() => _SlashCommandInputState();
}

class _SlashCommandInputState extends State<SlashCommandInput> {
  late TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  late final List<ChatCommand> _chatCommands = [
    ...CommandUtils.fixedCommands(),
    ...CommandUtils.fromVoiceCharacters(VoiceCharacter.values),
  ];
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

  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if (_overlayEntry != null) return; // 이미 오버레이가 있으면 return
    _overlayEntry ??= OverlayEntry(
      builder: (context) {
        final text = _controller.text;
        final query = text.startsWith("/") ? text.substring(1) : "";
        final matches = query.isEmpty
            ? _chatCommands
            : _chatCommands
                .where(
                    (c) => c.text.toLowerCase().contains(query.toLowerCase()))
                .toList();
        int commandsCount = widget.showCommandsCount ?? 5;

        const itemHeight = 40.0; // 리스트 아이템 하나 높이
        final totalHeight = matches.length * itemHeight;
        double offsetY = -20 - totalHeight; // TextField 위 20px + 리스트 높이만큼 위로 이동
        if (offsetY < -(commandsCount * itemHeight)) {
          // 최대 높이 제한
          offsetY = -(commandsCount * itemHeight);
        }
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
                child: SizedBox(
                  height: totalHeight > (commandsCount * itemHeight)
                      ? (commandsCount * itemHeight).toDouble()
                      : totalHeight.toDouble(),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final cmdText = matches[index].text;
                      int limittedLength =
                          matches.length > 5 ? 5 : matches.length;
                      return McAppear(
                        delayMs: limittedLength * 100 - (index * 100),
                        child: Listener(
                          behavior: HitTestBehavior.translucent, // 이벤트 전달
                          onPointerDown: (_) {
                            // 여기서 tap 처리
                            final replaced = "$cmdText ";
                            _controller
                              ..text = replaced
                              ..selection = TextSelection.collapsed(
                                  offset: replaced.length);
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
                                      TextSpan(text: cmdText),
                                    ],
                                  ),
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
