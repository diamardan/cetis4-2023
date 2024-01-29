import 'package:flutter/material.dart';

class DatamexFormButton extends StatefulWidget {
  DatamexFormButton(
      {Key? key,
      required this.color,
      required this.onPress,
      required this.label,
      this.textColor,
      this.enabled = true,
      this.icon})
      : super(key: key);

  final Color color;
  final void Function() onPress;
  final String label;
  Color? textColor;
  final bool enabled;
  IconData? icon;
  @override
  State<DatamexFormButton> createState() => _DatamexFormButtonState();
}

class _DatamexFormButtonState extends State<DatamexFormButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        widget.icon,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(backgroundColor: widget.color),
      onPressed: widget.enabled ? widget.onPress : null,
      label: Text(
        widget.label,
        style: TextStyle(color: widget.textColor),
      ),
    );
  }
}
