import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Models/liveCases_model.dart';
import 'package:orgone_app/Screen/Forms/tech_initiation.dart';
import 'package:orgone_app/Screen/Popups/schedule.dart';
import 'package:orgone_app/Screen/Popups/updateStatus.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';

class SearchScreen extends StatefulWidget {
  final List<LiveCasesModel> cases;
  const SearchScreen({super.key, required this.cases});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  dynamic data = [];
  List<LiveCasesModel> liveCases = [];
  String _searchText = '';
  final List<LiveCasesModel> _searchResults = [];
  String? updatedCaseStaus;
  TextEditingController caseStatusUpdateController = TextEditingController();

  callApi() async {
    // setState(() {
    //   isLoading = true;
    // });
    // var res = await getPostCall(historyUrl, {
    //   'user_code': constUserModel!.userCode,
    // });
    // setState(() {
    //   isLoading = false;
    // });

    // var getData = json.decode(res.body);
    // print(getData);

    // liveCases.addAll(
    //     (getData as List).map((e) => LiveCasesModel.fromJson(e)).toList());
    // liveCases
    //     .addAll((data as List).map((e) => LiveCasesModel.fromJson(e)).toList());
    liveCases.addAll(widget.cases);
    _searchResults.addAll(widget.cases);
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
        title: getNormalText('Search Cases', Colors.white, 16),
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
                                    Row(
                                      children: [
                                        _searchResults[index].priorityFlag ==
                                                'High'
                                            ? Icon(
                                                Icons.flag,
                                                color: Colors.red,
                                              )
                                            : Container(),
                                        getBoldText(_searchResults[index].vkid!,
                                            MyColors.primaryColor, 14),
                                      ],
                                    ),
                                    // ThreeDotMenu(
                                    //   vkid: liveCases[index]
                                    //       .vkid
                                    //       .toString(),
                                    // ),
                                    IconButton(
                                        onPressed: () {
                                          pushNavigate(
                                              context,
                                              TechInitiationForm(
                                                  vkid: _searchResults[index]
                                                      .vkid!,
                                                  isHistoryPage: false));
                                        },
                                        icon: Icon(Icons.edit))
                                  ],
                                ),
                                getDataRow('Location Name:',
                                    _searchResults[index].locationName ?? ' '),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    getSmallButton(
                                        'CASE STATUS UPDATE', Colors.green, () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return UpdateStatusDialog(
                                              vkid: liveCases[index]
                                                  .vkid
                                                  .toString(),
                                              setValue: (p0) {
                                                updatedCaseStaus = p0;
                                              },
                                              t: caseStatusUpdateController);
                                        },
                                      );
                                    }, getTotalWidth(context) / 3),
                                    getSmallButton('SCHEDULE', Colors.blue, () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ScheduleDialoge(
                                            vkid: liveCases[index]
                                                .vkid
                                                .toString(),
                                          );
                                        },
                                      );
                                    }, getTotalWidth(context) / 4),
                                    getSmallButton('CALL', Colors.deepOrange,
                                        () {
                                      makePhoneCall(liveCases[index]
                                          .mobileNo1
                                          .toString());
                                    }, getTotalWidth(context) / 4)
                                  ],
                                ),
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
