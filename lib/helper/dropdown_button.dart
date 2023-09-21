import 'package:flutter/material.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:search_choices/search_choices.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final List<String> itemList;
  final Function(String?) onChanged;
  final String? hint;
  final bool isRequired;

  const CustomDropdownButton({
    required this.value,
    required this.itemList,
    required this.onChanged,
    this.hint,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired
            ? Row(
                children: [
                  getBoldText(hint!, Colors.black, 14),
                  getBoldText('*', Colors.red, 14)
                ],
              )
            : getBoldText(hint!, Colors.black, 14),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          child: SearchChoices.single(
            hint: '',
            padding: EdgeInsets.zero,
            underline: Container(),
            items: itemList.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: value,
            // hint: "Select one",
            // searchHint: "Select one",
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:orgone_app/helper/utils.dart';

// class CustomDropdownButton extends StatelessWidget {
//   final String? value;
//   final List<String> itemList;
//   final Function(String?) onChanged;
//   final String? hint;

//   const CustomDropdownButton({
//     required this.value,
//     required this.itemList,
//     required this.onChanged,
//     this.hint,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         getBoldText(hint!, Colors.black, 14),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           height: 60,
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: DropdownSearch<String>(
//             // selectedItem: true,
//             // items: itemList,
//             // selectedItem: value,
//             // onChanged: onChanged,
//             // dropdownSearchDecoration: InputDecoration(
//             //   hintText: hint,
//             //   border: InputBorder.none,
//             // ),
//             popupProps: PopupProps.menu(
//               showSelectedItems: true,
//               // disabledItemFn: (String s) => s.startsWith('I'),
//             ),
//             items: itemList,

//             dropdownDecoratorProps: DropDownDecoratorProps(
//               dropdownSearchDecoration: InputDecoration(
//                 border: InputBorder.none,
//                 // labelText: hint,
//                 hintText: hint,
//               ),
//             ),

//             onChanged: onChanged,
//             selectedItem: value,
//           ),
//         ),
//         SizedBox(
//           height: 15,
//         ),
//       ],
//     );
//   }
// }
