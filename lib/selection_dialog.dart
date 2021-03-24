import 'package:country_picker_ar/model/country_picker.dart';
import 'package:flutter/material.dart';

class SelectionDialog extends StatefulWidget {
  final List<CountryInfo>? countries;
  final CountryInfo? selectedItem;
  final Function? selectCountry;
  final String? langCode;
  final String? hintText;

  const SelectionDialog({
    Key? key,
    this.countries,
    this.selectCountry,
    this.selectedItem,
    this.langCode,
    this.hintText = '...',
  }) : super(key: key);

  @override
  _SelectionDialogState createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  TextEditingController _controller = TextEditingController();
  List<CountryInfo>? _filteredCountries;
  @override
  void initState() {
    super.initState();
    _controller.addListener(filter);
    _filteredCountries = widget.countries;
  }

  filter() {
    String value = _controller.text.toLowerCase();
    setState(() {
      _filteredCountries = widget.countries!.where((e) {
        if (e.name!.toLowerCase().contains(value)) return true;
        if (e.nameEn!.toLowerCase().contains(value)) return true;
        if (e.nameAr!.toLowerCase().contains(value)) return true;
        if (e.code!.toLowerCase().contains(value)) return true;
        if (e.dialCode!.toLowerCase().contains(value)) return true;

        return false;
      }
          // (e) =>
          //     e.name!.toLowerCase().contains(value) ||
          //     e.nameEn!.toLowerCase().contains(value) ||
          //     e.nameAr!.toLowerCase().contains(value),
          ).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Flex(
        direction: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.blueGrey[50],
                  filled: true,
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          Expanded(
            child: ListView(
              // title: TextField(
              //   controller: _controller,
              //   decoration: InputDecoration(
              //       contentPadding: EdgeInsets.zero,
              //       prefixIcon: Icon(Icons.search),
              //       fillColor: Colors.blueGrey[50],
              //       filled: true,
              //       hintText: '...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(15),
              //         borderSide: BorderSide.none,
              //       )),
              // ),
              children: [
                if (widget.countries!.isEmpty)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ..._filteredCountries!.map((e) {
                  String? _name;
                  if (widget.langCode?.toString() == 'ar') {
                    _name = e.nameAr;
                  } else if (widget.langCode?.toString() == 'en') {
                    _name = e.nameEn;
                  } else {
                    _name = e.name;
                  }

                  return ListTile(
                    title: Text(_name!),
                    leading: Image.asset(
                      e.flagUri!,
                      package: 'country_picker_ar',
                      width: 32,
                    ),
                    selected: e.code == widget.selectedItem!.code,
                    trailing: e.code == widget.selectedItem!.code
                        ? Icon(Icons.check)
                        : Text(e.dialCode!),
                    onTap: () {
                      Navigator.of(context).pop(e);
                    },
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
