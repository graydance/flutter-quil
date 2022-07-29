import 'package:flutter/material.dart';

import '../../models/themes/quill_dialog_theme.dart';
import '../../models/themes/quill_icon_theme.dart';
import '../../translations/toolbar.i18n.dart';
import '../controller.dart';
import '../toolbar.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    this.iconTheme,
    this.dialogTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;

  final QuillController controller;
  final Color? fillColor;
  final QuillIconTheme? iconTheme;

  final QuillDialogTheme? dialogTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (_) => _SearchDialog(
          controller: controller, dialogTheme: dialogTheme, text: ''),
    ).then(_searchSubmitted);
  }

  void _searchSubmitted(String? value) {}
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog(
      {required this.controller, this.dialogTheme, this.text, Key? key})
      : super(key: key);

  final QuillController controller;
  final QuillDialogTheme? dialogTheme;
  final String? text;

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  late String _text;
  late TextEditingController _controller;
  late List<int>? _offsets;
  late int _index;

  @override
  void initState() {
    super.initState();
    _text = widget.text ?? '';
    _offsets = null;
    _index = 0;
    _controller = TextEditingController(text: _text);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      var label = '';
      if (_offsets != null) {
        label = '${_offsets!.length} ${'matches'.i18n}';
        if (_offsets!.isNotEmpty) {
          label += ', ${'showing match'.i18n} ${_index + 1}';
        }
      }
      return AlertDialog(
        backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
        content: Container(
          height: 100,
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.multiline,
                style: widget.dialogTheme?.inputTextStyle,
                decoration: InputDecoration(
                    labelText: 'Search'.i18n,
                    labelStyle: widget.dialogTheme?.labelTextStyle,
                    floatingLabelStyle: widget.dialogTheme?.labelTextStyle),
                autofocus: true,
                onChanged: _textChanged,
                controller: _controller,
              ),
              if (_offsets != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(label, textAlign: TextAlign.left),
                ),
            ],
          ),
        ),
        actions: [
          if (_offsets != null && _offsets!.isNotEmpty && _index > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _index -= 1;
                });
                widget.controller.moveCursorToPosition(_offsets![_index]);
              },
              child: Text(
                'Prev'.i18n,
                style: widget.dialogTheme?.labelTextStyle,
              ),
            ),
          if (_offsets != null &&
              _offsets!.isNotEmpty &&
              _index < _offsets!.length - 1)
            TextButton(
              onPressed: () {
                setState(() {
                  _index += 1;
                });
                widget.controller.moveCursorToPosition(_offsets![_index]);
              },
              child: Text(
                'Next'.i18n,
                style: widget.dialogTheme?.labelTextStyle,
              ),
            ),
          if (_offsets == null)
            TextButton(
              onPressed: () {
                setState(() {
                  _offsets = widget.controller.document.search(_text);
                  _index = 0;
                  debugPrint(_offsets.toString());
                });
                if (_offsets!.isNotEmpty) {
                  widget.controller.moveCursorToPosition(_offsets![0]);
                }
              },
              child: Text(
                'Ok'.i18n,
                style: widget.dialogTheme?.labelTextStyle,
              ),
            ),
        ],
      );
    });
  }

  void _textChanged(String value) {
    setState(() {
      _text = value;
      _offsets = null;
      _index = 0;
    });
  }
}