import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Models/liveCases_model.dart';
import 'package:orgone_app/Screen/Forms/tech_initiation.dart';
import 'package:orgone_app/Screen/Popups/schedule.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = false;
  dynamic data = [
    {
      "VKID": "IND20602230708",
      "INSTITUTION_TYPE": "Retail",
      "NAME": "Test Institution - Retail",
      "INST_DESC": "Indore",
      "REQUEST_DATE": "08-07-2023",
      "SCHEDULED_DATE": "08-07-2023",
      "FILE_REFNO": "",
      "ENG_DATE": "00-00-0000",
      "SUBMIT_STATUS_DATE": "0000-00-00 00:00:00",
      "ENG_TIME": "",
      "CALL_STATUS": "",
      "BORROWER_NAME": "Test For Auto Allocation",
      "CONTACT_PERSON": "Test for auto allocation",
      "MOBILE_NO_1": "",
      "MOBILE_NO_2": "",
      "MOBILE_NO_3": "",
      "LANDLINE_NO_1": "",
      "LANDLINE_NO_2": "",
      "LOAN_TYPE": "Resale",
      "LEGAL_DOCUMENT": "",
      "VISIT_ALLOCATED": "engineer",
      "VISIT_ALLOCATED_NAME": "Engineer",
      "PROPERTY_ADDRESS": "Test for auto allocation",
      "CASE_STATUS":
          "Visit Done - 08 July 2023, 04:28 PM - Data Submitted to Backoffice (Time: 08\/07\/2023 16:28)",
      "FLAT_NO": "",
      "FLOOR_WING": "",
      "SOCIETY_BUILDING": "",
      "PLOT_NO": "",
      "SECTOR_COLONY": "",
      "ROAD_AREA": "",
      "LOCATION": "AMBI",
      "LOCATION_NAME": "Ambivali",
      "CTS_SURVEY_VILLAGE": "",
      "DISTRICT": "",
      "SPL_INSTRUCTION": "NA",
      "PIN_CODE": "",
      "CREATED_DATE": "2023-07-08 16:12:27",
      "CREATED_BY": "admin",
      "MODIFIED_DATE": "",
      "MODIFIED_BY": "",
      "PRIORITY_FLAG": "High",
      "APP_SUBMIT_STATUS": "Not Submitted",
      "ORDER_CONDITION": "2023-07-08",
      "CAS_NO": "",
      "COPY_FLAG": "old",
      "OLD_CASE": null
    },
    {
      "VKID": "BOR20637230710",
      "INSTITUTION_TYPE": "Retail",
      "NAME": "Test Institution - Retail",
      "INST_DESC": "ashpak",
      "REQUEST_DATE": "10-07-2023",
      "SCHEDULED_DATE": "10-07-2023",
      "FILE_REFNO": "",
      "ENG_DATE": "00-00-0000",
      "SUBMIT_STATUS_DATE": "0000-00-00 00:00:00",
      "ENG_TIME": "",
      "CALL_STATUS": "",
      "BORROWER_NAME": "Test For Mobile Application 2",
      "CONTACT_PERSON": "test for mobile application 2",
      "MOBILE_NO_1": "",
      "MOBILE_NO_2": "",
      "MOBILE_NO_3": "",
      "LANDLINE_NO_1": "",
      "LANDLINE_NO_2": "",
      "LOAN_TYPE": "Bt Lap",
      "LEGAL_DOCUMENT": "",
      "VISIT_ALLOCATED": "engineer",
      "VISIT_ALLOCATED_NAME": "Engineer",
      "PROPERTY_ADDRESS": "test for mobile application 2",
      "CASE_STATUS": "",
      "FLAT_NO": "",
      "FLOOR_WING": "",
      "SOCIETY_BUILDING": "",
      "PLOT_NO": "",
      "SECTOR_COLONY": "",
      "ROAD_AREA": "",
      "LOCATION": "BELA",
      "LOCATION_NAME": "Belapur",
      "CTS_SURVEY_VILLAGE": "",
      "DISTRICT": "",
      "SPL_INSTRUCTION": "NA",
      "PIN_CODE": "",
      "CREATED_DATE": "2023-07-10 11:20:07",
      "CREATED_BY": "admin",
      "MODIFIED_DATE": "",
      "MODIFIED_BY": "",
      "PRIORITY_FLAG": "High",
      "APP_SUBMIT_STATUS": "Not Submitted",
      "ORDER_CONDITION": "2023-07-10",
      "CAS_NO": "",
      "COPY_FLAG": "old",
      "OLD_CASE": null
    },
    {
      "VKID": "BOR20679230710",
      "INSTITUTION_TYPE": "Retail",
      "NAME": "Test Institution - Retail",
      "INST_DESC": "ashpak",
      "REQUEST_DATE": "10-07-2023",
      "SCHEDULED_DATE": "10-07-2023",
      "FILE_REFNO": "",
      "ENG_DATE": "00-00-0000",
      "SUBMIT_STATUS_DATE": "0000-00-00 00:00:00",
      "ENG_TIME": "",
      "CALL_STATUS": "",
      "BORROWER_NAME": "Test",
      "CONTACT_PERSON": "TEST",
      "MOBILE_NO_1": "",
      "MOBILE_NO_2": "",
      "MOBILE_NO_3": "",
      "LANDLINE_NO_1": "",
      "LANDLINE_NO_2": "",
      "LOAN_TYPE": "Home Improvement",
      "LEGAL_DOCUMENT": "",
      "VISIT_ALLOCATED": "engineer",
      "VISIT_ALLOCATED_NAME": "Engineer",
      "PROPERTY_ADDRESS": "TEST",
      "CASE_STATUS": "",
      "FLAT_NO": "",
      "FLOOR_WING": "",
      "SOCIETY_BUILDING": "",
      "PLOT_NO": "",
      "SECTOR_COLONY": "",
      "ROAD_AREA": "",
      "LOCATION": "AMBE",
      "LOCATION_NAME": "Ambernath (E)",
      "CTS_SURVEY_VILLAGE": "",
      "DISTRICT": "",
      "SPL_INSTRUCTION": "NA",
      "PIN_CODE": "",
      "CREATED_DATE": "2023-07-10 12:45:09",
      "CREATED_BY": "admin",
      "MODIFIED_DATE": "",
      "MODIFIED_BY": "",
      "PRIORITY_FLAG": "High",
      "APP_SUBMIT_STATUS": "Not Submitted",
      "ORDER_CONDITION": "2023-07-10",
      "CAS_NO": "",
      "COPY_FLAG": "new",
      "OLD_CASE": null
    }
  ];
  List<LiveCasesModel> liveCases = [];
  String _searchText = '';
  final List<LiveCasesModel> _searchResults = [];
  callApi() async {
    setState(() {
      isLoading = true;
    });
    var res = await getPostCall(historyUrl, {
      'user_code': constUserModel!.userCode,
    });
    setState(() {
      isLoading = false;
    });

    var getData = json.decode(res.body);
    print(getData);

    liveCases.addAll(
        (getData as List).map((e) => LiveCasesModel.fromJson(e)).toList());
    // liveCases
    //     .addAll((data as List).map((e) => LiveCasesModel.fromJson(e)).toList());
    _searchResults.addAll(liveCases);
  }

  @override
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getNormalText('History', Colors.white, 16),
      ),
      body: isLoading
          ? getLoading()
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getBoldText(_searchResults[index].vkid!,
                                        MyColors.primaryColor, 14),
                                    ThreeDotMenu(
                                      isHistoryPage: true,
                                      vkid:
                                          _searchResults[index].vkid.toString(),
                                    ),
                                  ],
                                ),
                                getDataRow('Location Name:',
                                    _searchResults[index].locationName ?? ''),
                                getDataRow('Borrower Name:',
                                    _searchResults[index].borrowerName ?? ''),
                                getDataRow('Institute Name:',
                                    _searchResults[index].name ?? ''),
                                getDataRow('Contact Person:',
                                    _searchResults[index].contactPerson ?? ''),
                                getDataRow(
                                  'Address:',
                                  _searchResults[index].propertyAddress ?? '',
                                ),
                                getDataRow('Date of visit:',
                                    _searchResults[index].scheduledDate ?? ''),
                                getDataRow(
                                    'Date of Reschedule:',
                                    _searchResults[index].engDate ??
                                        '' +
                                            ' ' +
                                            _searchResults[index].engTime ??
                                        ''),
                                getDataRow('Special Instruction:',
                                    _searchResults[index].splInstruction ?? ''),
                                SizedBox(
                                  height: 15,
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: [
                                //     getSmallButton('CASE STATUS UPDATE',
                                //         Colors.green, () {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return UpdateStatusDialog(
                                //               vkid: liveCases[index]
                                //                   .vkid
                                //                   .toString(),
                                //               setValue: (p0) {
                                //                 updatedCaseStaus = p0;
                                //               },
                                //               t: caseStatusUpdateController);
                                //         },
                                //       );
                                //     }, getTotalWidth(context) / 3),
                                //     getSmallButton(
                                //         'SCHEDULE', Colors.blue, () {
                                //       showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return ScheduleDialoge(
                                //             vkid: liveCases[index]
                                //                 .vkid
                                //                 .toString(),
                                //           );
                                //         },
                                //       );
                                //     }, getTotalWidth(context) / 4),
                                //     getSmallButton(
                                //         'CALL', Colors.deepOrange, () {
                                //       makePhoneCall('9999999999');
                                //     }, getTotalWidth(context) / 4)
                                //   ],
                                // ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Search by ID and Borrower',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Icon(Icons.cancel))),
                    onChanged: (value) {
                      print(value);
                      List<LiveCasesModel> list = _getSearchSuggestions(value);
                      print(list);
                      setState(() {
                        _searchResults.clear();
                        _searchResults.addAll(list);
                      });
                    },
                    keyboardType: TextInputType.text,
                    //controller:
                  ),
                ),
              ],
            ),
    );
  }

  getDataRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              flex: 3,
              child: Container(
                width: getTotalWidth(context) * 2 / 5,
                child: getNormalText(title, Colors.grey, 14),
              )),
          Flexible(
              flex: 5,
              child: Container(
                width: getTotalWidth(context) * 3 / 5,
                child: getNormalText(value, Colors.black, 14),
              )),
        ],
      ),
    );
  }

  List<LiveCasesModel> _getSearchSuggestions(String query) {
    final lowercaseQuery = query.toLowerCase();
    return liveCases.where((liveCase) {
      final lowercaseBorrowerName = liveCase.borrowerName.toLowerCase();
      final vkidMatch =
          liveCase.vkid.toString().toLowerCase().contains(lowercaseQuery);
      final borrowerNameMatch = lowercaseBorrowerName
          .toString()
          .toLowerCase()
          .contains(lowercaseQuery);
      return vkidMatch || borrowerNameMatch;
    }).toList();
  }
}
