import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/images.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionOne.dart';
import 'package:orgone_app/Screen/Popups/mmSheet.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';

class MMSheetsForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const MMSheetsForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<MMSheetsForm> createState() => _MMSheetsFormState();
}

class _MMSheetsFormState extends State<MMSheetsForm> {
  List<Map<String, dynamic>> list = [];
  String _selectedAreaType = 'Residential';
  double balArea = 0;
  double carpetArea = 0;
  double otherArea = 0;
  double refugeArea = 0;
  double terraceArea = 0;

  bool isLoading = false;

  checkAndAddArea(String head, double val) {
    setState(() {
      if (head == 'Balcony') {
        balArea += val;
      }
      if (head == 'Carpet Area') {
        carpetArea += val;
      }
      if (head == 'Other Area') {
        otherArea += val;
      }
      if (head == 'Refuge Area') {
        refugeArea += val;
      }
      if (head == 'Terrace Area') {
        terraceArea += val;
      }
    });
  }

  saveForm() async {
    setState(() {
      isLoading = true;
    });

    List<String> group_heads = [];
    List<String> lengths = [];
    List<String> widths = [];
    List<String> sequence = [];
    List<String> area = [];
    List<String> name = [];
    list.forEach((element) {
      group_heads.add(element['group_head']);
      name.add(element['name']);
      sequence.add(element['sequence']);
      area.add(element['area']);
      widths.add(element['width']);
      lengths.add(element['length']);
    });
    Map<String, dynamic> data = {
      'vkid': widget.vkid,
      'created_by': constUserModel!.userCode,
      'type': _selectedAreaType == 'Residential' ? 'R' : 'C',
      // 'group_head[]': group_heads.toString(),
      // 'name[]': name.toString(),
      // 'sequence[]': sequence.toString(),
      // 'length[]': lengths.toString(),
      // 'width[]': widths.toString(),
      // 'area[]': area.toString(),
    };
    int i = 0;
    for (var element in list) {
      int i = list.indexOf(element);
      data['group_head[$i]'] = element['group_head'];
      data['name[$i]'] = element['name'];
      data['sequence[$i]'] = element['sequence'];
      data['length[$i]'] = element['length'];
      data['width[$i]'] = element['width'];
      data['area[$i]'] = element['area'];
      // i++;
    }

    print(data);

    var res = await getPostCall(mmSheetUrl, data);
    setState(() {
      isLoading = false;
    });
    print(res.body);
    var getData = json.decode(res.body);
    getSnackbar(getData['message'], context);
    if (getData['status'] == 'success') {
      pushNavigate(context,
          PhysicalInpectionOneForm(vkid: widget.vkid, isHistoryPage: false));
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
    var getData = json.decode(res.body);
    List<dynamic> data = getData['mmshet'];
    for (var element in data) {
      _selectedAreaType = element['TYPE'] == 'R' ? 'Residential' : 'Commercial';
      list.add({
        'group_head': element['GROUP_HEAD'],
        'name': element['NAME'].toString(),
        'sequence': element['SEQUENCE'].toString(),
        'length': element['LENGTH'].toString(),
        'width': element['WIDTH'].toString(),
        'area': element['AREA'].toString(),
      });
      checkAndAddArea(element['GROUP_HEAD'], double.parse(element['AREA']));
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
        title: getBoldText('MM Sheets', Colors.white, 16),
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
                    ImagesForm(
                        vkid: widget.vkid,
                        isHistoryPage: widget.isHistoryPage));
                return Future.delayed(Duration.zero);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getBoldText('Area Type', Colors.black, 16),
                          SizedBox(height: 10.0),
                          IntrinsicHeight(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: RadioListTile(
                                    title: Text('Residential'),
                                    value: 'Residential',
                                    groupValue: _selectedAreaType,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAreaType = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: RadioListTile(
                                    title: Text('Commercial'),
                                    value: 'Commercial',
                                    groupValue: _selectedAreaType,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAreaType = value.toString();
                                      });
                                    },
                                  ),
                                ),
                                // Flexible(
                                //   flex: 1,
                                //   child: RadioListTile(
                                //     title: Text('Residental & Commercial'),
                                //     value: 'Residental & Commercial',
                                //     groupValue: _selectedAreaType,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         _selectedAreaType = value.toString();
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Dimensions', Colors.black, 16),
                      SizedBox(height: 10.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 35,
                          dataRowHeight: 35,
                          headingTextStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => MyColors.primaryColor),
                          border: TableBorder.all(
                            color: Colors.grey,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(label: Text('Group Head')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Sequence')),
                            DataColumn(label: Text('Length')),
                            DataColumn(label: Text('Width')),
                            DataColumn(label: Text('Area')),
                          ],
                          rows: list
                              .map((e) => DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            GestureDetector(
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  list.remove(e);
                                                  checkAndAddArea(
                                                      e['group_head'],
                                                      -double.parse(e['area']));
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(e['group_head'])),
                                      DataCell(Text(e['name'])),
                                      DataCell(Text(e['sequence'])),
                                      DataCell(Text(e['length'])),
                                      DataCell(Text(e['width'])),
                                      DataCell(Text(e['area'])),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getSmallButton('ADD FIELD', Colors.green, () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddMMSheetDialog(
                                  type: _selectedAreaType,
                                  function: (Map<String, dynamic> val) {
                                    print(val);
                                    setState(() {
                                      list.add(val);
                                    });
                                    checkAndAddArea(val['group_head'],
                                        double.parse(val['area']));
                                  },
                                );
                              },
                            );
                          }, getTotalWidth(context) / 4)
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      DataTable(
                          headingRowHeight: 35,
                          dataRowHeight: 35,
                          headingTextStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => MyColors.primaryColor),
                          border: TableBorder.all(
                            color: Colors.grey,
                          ),
                          columns: const [
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Area')),
                          ],
                          rows: [
                            DataRow(cells: [
                              DataCell(Text('Balcony')),
                              DataCell(Text(balArea.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Carpet Area')),
                              DataCell(Text(carpetArea.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Other Area')),
                              DataCell(Text(otherArea.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Refuge Area')),
                              DataCell(Text(refugeArea.toString())),
                            ]),
                            DataRow(cells: [
                              DataCell(Text('Terrace Area')),
                              DataCell(Text(terraceArea.toString())),
                            ]),
                          ]),
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
                      //                 ImagesForm(
                      //                   vkid: widget.vkid,
                      //                 ));
                      //           },
                      //           child: getNormalText(
                      //               '<< Previous Form', Colors.black, 16),
                      //         ),
                      //         getNormalText('|', Colors.black, 16),
                      //         GestureDetector(
                      //           onTap: () {
                      //             pushReplacementNavigate(
                      //                 context,
                      //                 PhysicalInpectionOneForm(
                      //                     vkid: widget.vkid));
                      //           },
                      //           child: getNormalText(
                      //               'Next Form >>', Colors.black, 16),
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
    );
  }
}
