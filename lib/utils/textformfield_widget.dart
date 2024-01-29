import 'package:cetis4/utils/email_validator.dart';
import 'package:cetis4/utils/uppercase_text_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class DatamexTextFormField extends StatefulWidget {
  const DatamexTextFormField({
    Key? key,
    required this.labelText,
    required this.boxHeight,
    required this.controller,
    this.onChanged,
    this.validate = false, // Valor predeterminado: false,
    this.minLength = 1,
    this.maxLength = 50,
    this.isEmail = false,
    this.keyboardType = TextInputType.text, // Valor predeterminado
    this.acceptDiacritics = false,
    this.enabled = true,
  }) : super(key: key);
  final String labelText;
  final double boxHeight;
  final TextEditingController controller; // Define el controlador
  final Function(String)? onChanged;
  final bool validate;
  final int minLength;
  final int maxLength;
  final TextInputType keyboardType; // Usar el enum como tipo de teclado
  final bool isEmail;
  final bool acceptDiacritics;
  final bool enabled;
  @override
  State<DatamexTextFormField> createState() => _DatamexTextFormFieldState();
}

class _DatamexTextFormFieldState extends State<DatamexTextFormField> {
  final List<TextInputFormatter> _inputFormatters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inputFormatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    widget.isEmail
        ? _inputFormatters.add(LowerCaseTextFormatter())
        : _inputFormatters.add(UpperCaseTextFormatter());
    if (widget.keyboardType == TextInputType.number) {
      _inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    widget.controller.addListener(updateTextField);
  }

  String sanitizeText(String text) {
    final diacriticsToKeep = {'ñ', 'Ñ'};

    String output = '';

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (diacriticsToKeep.contains(char)) {
        output += char;
      } else {
        output += removeDiacritics(char);
      }
    }

    return output;
  }

  void updateTextField() {
    final text = widget.controller.text;
    if (!widget.acceptDiacritics) {
      final sanitizedText = sanitizeText(text);
      if (sanitizedText != text) {
        final selection = widget.controller.selection;
        widget.controller.value = TextEditingValue(
          text: sanitizedText,
          selection: TextSelection.collapsed(offset: selection.baseOffset),
        );
      }
      if (widget.onChanged != null) {
        widget.onChanged!(sanitizedText);
      }
    }
    setState(() {}); // Llamada a setState para actualizar el widget
  }

  @override
  void dispose() {
    /* _textEditingController.dispose(); */
    super.dispose();
    widget.controller.removeListener(updateTextField);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: widget.keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          onChanged: widget.onChanged,
          inputFormatters: _inputFormatters,
          enabled: widget.enabled,
          validator: (value) {
            print('😁😁😁');
            print(widget.validate);
            if (!widget.validate) {
              return null;
            } else {
              if (widget.validate == true && (value!.trim().isEmpty)) {
                return 'Este campo no puede estar vacío';
              }
              if (value!.trim().length < widget.minLength) {
                return 'Faltan caracteres ';
              }
              if (widget.isEmail && !isEmailValid(value)) {
                return 'El correo no tiene un formato válido';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
            counterText: '${widget.controller.text.length}/${widget.maxLength}',
          ),
        ),
        SizedBox(
          height: widget.boxHeight,
        ),
      ],
    );
  }
}
