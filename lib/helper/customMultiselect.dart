// import 'package:flutter/material.dart';
// import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
// import 'package:multi_select_flutter/util/multi_select_list_type.dart';

// class CustomMultiSelectDropdown extends StatefulWidget {
//    final String? value;
//   final List<String> itemList;
//   final Function(String?) onChanged;
//   final String? hint;
//   final bool isRequired;
//   const CustomMultiSelectDropdown({super.key,
//    required this.value,
//     required this.itemList,
//     required this.onChanged,
//     this.hint,
//     this.isRequired = true,
//   });

//   @override
//   State<CustomMultiSelectDropdown> createState() => _CustomMultiSelectDropdownState();
// }

// class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiSelectDialogField(
//   items: widget.itemList.map((e) => MultiSelectItem(e, e)).toList(),
//   listType: MultiSelectListType.CHIP,
//   onConfirm: (values) {
//     widget.value = values;
//   },
// );
//   }
// }