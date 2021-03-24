library country_picker_ar;

import 'package:flutter/material.dart';

import 'selection_dialog.dart';
import 'model/country_picker.dart';
import 'countries_list.dart';

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
      selectedItem = elements
          .firstWhere((element) => element.code == widget.initialSelection);
    } else {
      selectedItem = elements.elementAt(0);
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
        setState(() {
          selectedItem = e;
          widget.onSelect!(e);
        });
        // _publishSelection(e);
      }
    });
  }
}
