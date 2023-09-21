import 'dart:convert' as c;

import 'package:flutter/material.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/ndma.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';

class CaseStatusForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const CaseStatusForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<CaseStatusForm> createState() => _CaseStatusFormState();
}

class _CaseStatusFormState extends State<CaseStatusForm> {
  TextEditingController receptionController = TextEditingController();
  TextEditingController branchOfficerController = TextEditingController();

  TextEditingController engineerController = TextEditingController();

  TextEditingController caseStatusController = TextEditingController();

  TextEditingController preCaseStatusController = TextEditingController();

  String? status;
  List<String> statusList = [
    'Visit Done',
    'Visit Failed',
    'Partial Visit Done',
    'Hold Application'
  ];

  List<String> caseStatusParam = [];
  String? selectedParam;

  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();

  getCaseStausParam(String value) async {
    caseStatusParam.clear();
    selectedParam = null;
    var res = await getPostCall(caseStatusParamUrl, {'status_type': value});
    var getData = c.json.decode(res.body);
    if (getData['status'] == 'success') {
      getData['status_list'].forEach((e) {
        caseStatusParam.add(e.toString());
      });
      selectedParam = caseStatusParam[0];
      caseStatusController.text =
          '$status - ${formatDateTimeWithTime(DateTime.now().toString())} - $selectedParam';
    }
    setState(() {});
    print(getData);
  }

  saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (status == null) {
        getSnackbar('Status is required', context);
        return;
      }
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'reception': receptionController.text,
        'engineer': engineerController.text,
        'senior_manager': branchOfficerController.text,
        'status_type': status,
        'pre_case_status': preCaseStatusController.text,
        'case_status': caseStatusController.text,
        'technical_manager': '',
        'fees': '',
        'send_report': '',
        'created_date': formatDateTimeMonth(DateTime.now().toString())
      };
      var res = await getPostCall(caseStautsFormUrl, data);
      print(res.body);
      setState(() {
        isLoading = false;
      });
      var getData = c.json.decode(res.body);
      if (getData['status'] == 'success') {
        pushAndRemoveUntilNavigate(context, HomeScreen());
      }
      getSnackbar(getData['message'], context);
    }
  }

  getInitialData() async {
    setState(() {
      isLoading = true;
    });
    var res = await getPostCall(caseDetailUrl, {'vkid': widget.vkid});
    setState(() {
      isLoading = false;
    });
    var getData = c.json.decode(res.body);
    Map<String, dynamic> data = getData['caseStatus'];
    print(data);

    try {
      status = statusList.firstWhere((element) {
        return element == data['STATUS_TYPE'];
      }).toString();
      getCaseStausParam(status!);
    } catch (e) {
      status = null;
    }
    try {
      receptionController.text = data['RECEPTION'].toString();
    } catch (e) {
      receptionController.text = '';
    }
    try {
      branchOfficerController.text = data['SENIOR_MANAGER'].toString();
    } catch (e) {
      branchOfficerController.text = '';
    }

    try {
      engineerController.text = data['ENGINEER'].toString();
    } catch (e) {
      engineerController.text = '';
    }
    // try {
    //   caseStatusController.text = data['CASE_STATUS'].toString();
    // } catch (e) {
    //   caseStatusController.text = '';
    // }
    try {
      preCaseStatusController.text = data['PRE_CASE_STATUS'] ?? '';
    } catch (e) {
      preCaseStatusController.text = '';
    }

    print(data);
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getBoldText('Case Status', Colors.white, 16),
        actions: [
          IconButton(
              onPressed: () {
                pushAndRemoveUntilNavigate(context, HomeScreen());
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              )),
          ThreeDotMenu(
            isHistoryPage: widget.isHistoryPage,
            vkid: widget.vkid,
          ),
        ],
      ),
      bottomSheet: Container(
        height: 40,
        child: widget.isHistoryPage
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getButton('Submit to Orgone', MyColors.primaryColor,
                      MyColors.secondaryColor, () {
                    saveForm();
                  }, getTotalWidth(context))
                ],
              ),
      ),
      body: isLoading
          ? getLoading()
          : WillPopScope(
              onWillPop: () async {
                pushNavigate(
                    context,
                    NDMAForm(
                        vkid: widget.vkid,
                        isHistoryPage: widget.isHistoryPage));
                return Future.delayed(Duration.zero);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Reception',
                            t: receptionController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Branch Officer',
                            t: branchOfficerController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Engineer',
                            t: engineerController),
                        CustomDropdownButton(
                          value: status,
                          itemList: statusList,
                          onChanged: (newValue) {
                            setState(() {
                              status = newValue!;
                            });
                            getCaseStausParam(status!);
                            caseStatusController.text =
                                '$status - ${formatDateTimeWithTime(DateTime.now().toString())} ';
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
                                  caseStatusController.text =
                                      '$status - ${formatDateTimeWithTime(DateTime.now().toString())} - $selectedParam';
                                },
                                hint: '$status',
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getBoldText('Case Status', Colors.black, 14),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              minLines: 3,
                              maxLines: 5,
                              textInputAction: TextInputAction.next,
                              controller: caseStatusController,
                              decoration: InputDecoration(
                                  // label: getNormalText(
                                  //     'Case Status', Colors.black, 14),
                                  // hintStyle:
                                  //     TextStyle(fontSize: 14, color: Colors.grey),
                                  // hintText: 'Case Status',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Pre Case status',
                            t: preCaseStatusController),
                        SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          height: 50,
                        ),
                        // Spacer(),
                        // Container(
                        //   decoration: BoxDecoration(border: Border.all()),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         GestureDetector(
                        //           onTap: () {
                        //             pushReplacementNavigate(
                        //                 context,
                        //                 NDMAForm(
                        //                   vkid: widget.vkid,
                        //                 ));
                        //           },
                        //           child: getNormalText(
                        //               '<< Previous Form', Colors.black, 16),
                        //         ),
                        //         getNormalText('|', Colors.black, 16),
                        //         GestureDetector(
                        //           onTap: () {},
                        //           child: getNormalText(
                        //               'Next Form >>', Colors.grey, 16),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
