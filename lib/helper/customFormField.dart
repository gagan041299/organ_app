import 'package:flutter/material.dart';
import 'package:orgone_app/helper/utils.dart';

class CustomFormFiled extends StatefulWidget {
  final Function(String) setter;
  final String title;
  final bool isRequired;
  final TextInputType keyboardType;
  final TextEditingController t;
  final bool readOnly;
  const CustomFormFiled(
      {super.key,
      required this.setter,
      required this.title,
      this.isRequired = true,
      this.keyboardType = TextInputType.text,
      this.readOnly = false,
      required this.t});

  @override
  State<CustomFormFiled> createState() => _CustomFormFiledState();
}

class _CustomFormFiledState extends State<CustomFormFiled> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // getBoldText(widget.isRequired ? '${widget.title}*' : widget.title,
        //     widget.readOnly ? Colors.grey.shade500 : Colors.black, 14),
        widget.isRequired
            ? Row(
                children: [
                  getBoldText(widget.title, Colors.black, 14),
                  getBoldText('*', Colors.red, 18)
                ],
              )
            : getBoldText(widget.title, Colors.black, 14),
        SizedBox(
          height: 8,
        ),
        Container(
          color: widget.readOnly ? Colors.grey.shade300 : Colors.transparent,
          child: TextFormField(
            onChanged: widget.setter,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return widget.isRequired ? 'This field is required' : null;
              }
              return null;
            },
            controller: widget.t,
            decoration: InputDecoration(
              isDense: true,
              // label: getNormalText(widget.title, Colors.black, 14),
              // hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              // hintText: widget.title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
