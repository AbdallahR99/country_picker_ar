library country_picker_ar;

import 'dart:developer';

import 'package:flutter/material.dart';

import 'selection_dialog.dart';
import 'model/country_picker.dart';
import 'countries_list.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

typedef void OnSelectFun(CountryInfo param);

class CountryPicker extends StatefulWidget {
  final String? initialSelection;
  final double flagWidth;
  final OnSelectFun? onSelect;
  final String? langCode;
  final String? hintText;
  const CountryPicker({
    Key? key,
    this.initialSelection,
    this.flagWidth = 32.0,
    this.onSelect,
    this.langCode,
    this.hintText = '...',
  }) : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<CountryInfo> elements = [];
  CountryInfo? selectedItem;
  @override
  void initState() {
    elements = countryPickerFromMap(getCountriesList());
    if (widget.initialSelection != null) {
      try {
        final _item = elements.firstWhereOrNull(
            (element) => element.code == widget.initialSelection);
        if (_item != null) {
          _selectItem(_item);
        } else {
          final _item = elements.firstWhereOrNull(
              (element) => element.dialCode == widget.initialSelection);
          if (_item != null) {
            _selectItem(_item);
          } else {
            _selectItem(elements.elementAt(0));
          }
        }
      } catch (e) {
        log(e.toString());
        _selectItem(elements.elementAt(0));
      }
    } else {
      // selectedItem = elements.elementAt(0);
      _selectItem(elements.elementAt(0));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Image.asset(
        selectedItem!.flagUri!,
        package: 'country_picker_ar',
        width: widget.flagWidth,
      ),
      label: Text(selectedItem?.dialCode ?? ''),
      onPressed: showCountryCodePickerDialog,
    );
  }

  void showCountryCodePickerDialog() {
    showDialog(
      // backgroundColor: widget.backgroundColor ?? Colors.transparent,
      context: context,
      builder: (context) => Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: SelectionDialog(
            countries: elements,
            selectedItem: selectedItem,
            langCode: widget.langCode,
            hintText: widget.hintText,
          ),
        ),
      ),
    ).then((e) {
      if (e != null) {
        _selectItem(e);
        // _publishSelection(e);
      }
    });
  }

  void _selectItem(CountryInfo e) {
    setState(() {
      selectedItem = e;
      widget.onSelect!(e);
    });
  }
}
