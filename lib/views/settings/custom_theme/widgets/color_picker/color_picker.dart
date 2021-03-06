import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../shared/general/themed/themed_cupertino_button.dart';
import '../../../../../types/extensions/string.dart';
import '../../../../../utils/validation_helper.dart';
import '../../../widgets/action_block.dart/light_divider.dart';
import 'color_bubble.dart';
import 'color_slider.dart';

class ColorPicker extends StatefulWidget {
  final String title;
  final String description;
  final String? color;
  final bool useAlpha;
  final void Function(String)? onSave;

  ColorPicker({
    required this.title,
    required this.description,
    this.color,
    this.useAlpha = false,
    this.onSave,
  });

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late TextEditingController _color;
  FocusNode _colorFocusNode = FocusNode();
  late Key _colorContainerKey;

  @override
  void initState() {
    _color = TextEditingController(text: this.widget.color ?? '000000');
    _colorFocusNode.addListener(() {
      if (_colorFocusNode.hasFocus) {
        _color.selection =
            TextSelection(baseOffset: 0, extentOffset: _color.text.length);
      }
    });
    _colorContainerKey = Key(this.widget.color ?? '000000');
    super.initState();
  }

  int _getColorSliderValue(int begin) =>
      int.parse(_color.text.substring(begin, begin + 2), radix: 16);

  void _onColorSlideChange(String value, int begin) {
    String hex = int.parse(value).toRadixString(16);
    _color.text = _color.text
        .replaceRange(begin, begin + 2, hex.length == 1 ? '0$hex' : hex);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0, right: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  this.widget.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Row(
                children: [
                  ThemedCupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'Cancel',
                  ),
                  ThemedCupertinoButton(
                    onPressed: () {
                      this.widget.onSave?.call(_color.text);
                      Navigator.of(context).pop();
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
          child: Text(
            this.widget.description,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        LightDivider(),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // height: 50.0,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 24.0),
                              child: Text(
                                'Hex:',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            SizedBox(
                              width: 150.0,
                              child: TextFormField(
                                controller: _color,
                                focusNode: _colorFocusNode,
                                decoration: InputDecoration(isDense: true),
                                validator: (color) =>
                                    ValidationHelper.colorHexValidator(color),
                                autovalidateMode: AutovalidateMode.always,
                                autocorrect: false,
                                maxLength: this.widget.useAlpha ? 8 : 6,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(
                                //     r'^[a-fA-F0-9]+$',
                                //     replacementString: _color.text,
                                //   )
                                // ],
                                onChanged: (value) {
                                  if (ValidationHelper.colorHexValidator(
                                          _color.text) ==
                                      null) {
                                    _colorContainerKey = Key(_color.text);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ColorBubble(
                          color: _color.text.hexToColor(),
                          size: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
                LightDivider(),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 24.0, right: 16.0),
                  child: Column(
                    key: _colorContainerKey,
                    children: [
                      ColorSlider(
                        label: 'R',
                        value:
                            _getColorSliderValue(this.widget.useAlpha ? 2 : 0),
                        activeColor: CupertinoColors.destructiveRed,
                        onChanged: (colorVal) => _onColorSlideChange(
                            colorVal, this.widget.useAlpha ? 2 : 0),
                      ),
                      ColorSlider(
                        label: 'G',
                        value:
                            _getColorSliderValue(this.widget.useAlpha ? 4 : 2),
                        activeColor: Colors.green,
                        onChanged: (colorVal) => _onColorSlideChange(
                            colorVal, this.widget.useAlpha ? 4 : 2),
                      ),
                      ColorSlider(
                        label: 'B',
                        value:
                            _getColorSliderValue(this.widget.useAlpha ? 6 : 4),
                        activeColor: Colors.blue,
                        onChanged: (colorVal) => _onColorSlideChange(
                            colorVal, this.widget.useAlpha ? 6 : 4),
                      ),
                      if (this.widget.useAlpha)
                        ColorSlider(
                          label: 'A',
                          value: _getColorSliderValue(0),
                          activeColor: Colors.white,
                          onChanged: (colorVal) =>
                              _onColorSlideChange(colorVal, 0),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 12.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
