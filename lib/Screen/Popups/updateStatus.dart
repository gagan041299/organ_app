import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/utils.dart';

class UpdateStatusDialog extends StatefulWidget {
  final String vkid;
  final TextEditingController t;
  final Function(String?) setValue;
  const UpdateStatusDialog(
      {super.key, required this.setValue, required this.t, required this.vkid});

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
  List<String> statusList = [
    'Visit Done',
    'Visit Failed',
    'Partial Visit Done',
    'Hold Application'
  ];
  saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedValue == null) {
        getSnackbar('Status is required', context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'status_type': selectedValue,
        'case_status': widget.t.text,
        'created_date': formatDateTimeMonth(DateTime.now().toString()),
        'reception': '',
        'engineer': '',
        'senior_manager': '',
        'pre_case_status': '',
        'technical_manager': '',
        'fees': '',
        'send_report': '',
      };
      var res = await getPostCall(caseStautsFormUrl, data);
      print(res.body);
      setState(() {
        isLoading = false;
      });
      var getData = json.decode(res.body);
      getSnackbar(getData['message'], context);
    }
  }

  List<String> caseStatusParam = [];
  String? selectedParam;

  getCaseStausParam(String value) async {
    caseStatusParam.clear();
    selectedParam = null;
    var res = await getPostCall(caseStatusParamUrl, {'status_type': value});
    var getData = json.decode(res.body);
    if (getData['status'] == 'success') {
      getData['status_list'].forEach((e) {
        caseStatusParam.add(e.toString());
      });
      selectedParam = caseStatusParam[0];
      widget.t.text =
          '$selectedValue - ${formatDateTimeWithTime(DateTime.now().toString())} - $selectedParam';
    }
    setState(() {});
    print(getData);
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(10),
      buttonPadding: EdgeInsets.all(20),
      title: Container(
          padding: EdgeInsets.all(10),
          width: getTotalWidth(context),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: MyColors.primaryColor,
          ),
          child: getNormalText('Update Case Status', Colors.white, 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdownButton(
            value: selectedValue,
            itemList: statusList,
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue!;
              });
              getCaseStausParam(selectedValue!);
              widget.t.text =
                  '$selectedValue - ${formatDateTimeWithTime(DateTime.now().toString())} ';
            },
            hint: 'Status',
          ),
          caseStatusParam.isEmpty
              ? Container()
              : CustomDropdownButton(
                  value: selectedParam,
                  itemList: caseStatusParam,
                  onChanged: (newValue) {
                    setState(() {
                      selectedParam = newValue!;
                    });
                    widget.t.text =
                        '$selectedValue - ${formatDateTimeWithTime(DateTime.now().toString())} - $selectedParam';
                  },
                  hint: '$selectedValue',
                ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: widget.t,
              key: widget.key,
              decoration: InputDecoration(
                hintText: 'Case Status',
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      actions: [
        getSmallButton('UPDATE', MyColors.primaryColor, () async {
          await saveForm();
          Navigator.of(context).pop();
        }, getTotalWidth(context) / 4),
        getSmallButton('CANCEL', Colors.red, () {
          Navigator.of(context).pop();
        }, getTotalWidth(context) / 4),
      ],
    );
  }
}
