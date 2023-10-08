import 'package:flutter/material.dart';
import 'arrow_button.dart';

import '../constants/enums.dart';

class ArrowGroup extends StatefulWidget {
  final ArrowGoupAxis axis;
  final int likesCount;
  final ArrowButtonSelected? selectedValue;
  final Function(int delta) onChange;
  const ArrowGroup({
    super.key,
    this.selectedValue,
    required this.axis,
    required this.onChange,
    required this.likesCount,
  });

  @override
  State<ArrowGroup> createState() => _ArrowGroupState();
}

class _ArrowGroupState extends State<ArrowGroup> {
  int count = 0;
  @override
  void initState() {
    count = widget.likesCount;
    selectedValue = widget.selectedValue;
    super.initState();
  }

  ArrowButtonSelected? selectedValue;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      ArrowButton(
        direction: ArrowButtonDirection.UP,
        selected: selectedValue == ArrowButtonSelected.UP,
        onPressed: () {
          int delta = 0;
          setState(() {
            if (selectedValue == ArrowButtonSelected.UP) {
              selectedValue = null;
              delta = -1;
            } else if (selectedValue == ArrowButtonSelected.DOWN) {
              selectedValue = ArrowButtonSelected.UP;
              delta = 2;
            } else {
              selectedValue = ArrowButtonSelected.UP;
              delta = 1;
            }
          });
          count += delta;
          widget.onChange(delta);
        },
      ),
      Container(
        width: 24,
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$count',
          ),
        ),
      ),
      ArrowButton(
        direction: ArrowButtonDirection.DOWN,
        selected: selectedValue == ArrowButtonSelected.DOWN,
        onPressed: () {
          int delta = 0;
          setState(() {
            if (selectedValue == ArrowButtonSelected.DOWN) {
              selectedValue = null;
              delta = 1;
            } else if (selectedValue == ArrowButtonSelected.UP) {
              selectedValue = ArrowButtonSelected.DOWN;
              delta = -2;
            } else {
              selectedValue = ArrowButtonSelected.DOWN;
              delta = -1;
            }
            count += delta;
            widget.onChange(delta);
          });
        },
      ),
    ];
    if (widget.axis == ArrowGoupAxis.VERTICAL) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
