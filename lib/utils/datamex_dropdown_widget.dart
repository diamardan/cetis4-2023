import 'package:cetis4/utils/common_response.dart';
import 'package:flutter/material.dart';

class DatamexDropDownMenuWidget<T extends CommonResponse>
    extends StatefulWidget {
  const DatamexDropDownMenuWidget(
      {Key? key,
      required this.items,
      required this.labelText,
      required this.onChanged,
      required this.initialValue,
      this.isEnabled = true})
      : super(key: key);

  final List<T> items;
  final String labelText;
  final void Function(T selectedValue) onChanged;
  final String initialValue;
  final bool isEnabled;

  @override
  _DatamexDropDownMenuWidgetState<T> createState() =>
      _DatamexDropDownMenuWidgetState<T>();
}

class _DatamexDropDownMenuWidgetState<T extends CommonResponse>
    extends State<DatamexDropDownMenuWidget<T>> {
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem =
        widget.items.firstWhereOrNull((item) => item.id == widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<T>(
          isExpanded: true,
          dropdownColor: Colors.white,
          elevation: 0,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: _selectedItem,
          onChanged: widget.isEnabled
              ? (T? newValue) {
                  widget.onChanged(newValue!);
                  setState(() {
                    _selectedItem = newValue;
                  });
                }
              : null,
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(_getDisplayText(item)),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: widget.labelText,
          ),
          validator: (value) {
            if (value == null) {
              return 'Debe seleccionar una opción';
            }
            return null;
          },
          selectedItemBuilder: (BuildContext context) {
            return widget.items.map<Widget>((T item) {
              return Text(_getDisplayText(item));
            }).toList();
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  String _getDisplayText(T item) {
    return item.name;
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
