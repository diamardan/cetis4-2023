import 'package:cetis4/config/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class DatamexSignaturePad extends StatefulWidget {
  const DatamexSignaturePad({Key? key, required this.controller})
      : super(key: key);
  @override
  State<DatamexSignaturePad> createState() => _DatamexSignaturePadState();
  final HandSignatureControl controller;
}

class _DatamexSignaturePadState extends State<DatamexSignaturePad> {
  bool blockVerticalScroll = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (_) {
        setState(() {
          blockVerticalScroll = false;
        });
      },
      onVerticalDragEnd: (_) {
        setState(() {
          blockVerticalScroll = false;
        });
      },
      child: AbsorbPointer(
        absorbing: blockVerticalScroll,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: HandSignature(
                control: widget.controller,
                color: Colors.black,
                type: SignatureDrawType.line,
                width: 1.8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.undo),
                    label: const Text('Deshacer firma'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
