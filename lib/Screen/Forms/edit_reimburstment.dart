import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Models/reimburstment_model.dart';
import 'package:orgone_app/Screen/Forms/reimburstment.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:http/http.dart' as http;

class EditReimburstmentForm extends StatefulWidget {
  final String reqDate;
  final String reqId;
  final double pricePerKm;
  const EditReimburstmentForm(
      {super.key,
      required this.reqDate,
      required this.reqId,
      required this.pricePerKm});

  @override
  State<EditReimburstmentForm> createState() => _EditReimburstmentFormState();
}

class _EditReimburstmentFormState extends State<EditReimburstmentForm> {
  final ImagePicker _picker = ImagePicker();
  XFile? reimburstmentFile;

  Future selectImageGalleryDrawing() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      reimburstmentFile = XFile(photo!.path);
    });
  }

  Future selectImageCameraDrawing() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      reimburstmentFile = XFile(photo!.path);
    });
  }

  List<TextEditingController> selectedDate = [TextEditingController()];
  List<DateTime> selectedDateList = [DateTime.now()];
  List<TextEditingController> selectedParticular = [TextEditingController()];
  List<TextEditingController> selectedNoOfVisit = [TextEditingController()];
  List<TextEditingController> selectedTravelKm = [TextEditingController()];
  List<TextEditingController> selectedTravelRs = [TextEditingController()];
  List<TextEditingController> selectedFood = [TextEditingController()];
  List<TextEditingController> selectedStationary = [TextEditingController()];
  List<TextEditingController> selectedOther = [TextEditingController()];
  List<TextEditingController> selectedTotal = [TextEditingController()];
  List<TextEditingController> selectedRemark = [TextEditingController()];
  TextEditingController selectedVisitTotal = TextEditingController();
  TextEditingController selectedTravelKmTotal = TextEditingController();
  TextEditingController selectedTravelRsTotal = TextEditingController();
  TextEditingController selectedFoodTotal = TextEditingController();
  TextEditingController selectedStationaryTotal = TextEditingController();
  TextEditingController selectedOtherTotal = TextEditingController();
  TextEditingController selectedTotalTotal = TextEditingController();
  List<String> idList = [];

  bool isLoading = false;
  List<ReimburstmentModel> reimburstmentList = [];
  String? fileUrl;
  String baseUrl =
      'https://api.orgone.solutions/orgon_api/api/reimbursement_file/';

  Future<void> _selectDate(BuildContext context, pickedDate, index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
        selectedDateList[index] = picked;

        selectedDate[index].text =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(picked.toString()));
        getNoOfVisit(selectedDate[index].text, index);
      });
      print(selectedDate);
    }
  }

  getNoOfVisit(String date, int index) async {
    var res = await getPostCall(caseCountUrl, {
      'expenses_date': date,
      'created_by': constUserModel!.userCode,
    });

    var getData = json.decode(res.body);
    print(getData);

    selectedNoOfVisit[index].text = getData['data']['NO_OF_VISIT'].toString();
  }

  getTotal() {
    selectedVisitTotal.text = '0';
    selectedTravelKmTotal.text = '0';
    selectedTravelRsTotal.text = '0';
    selectedFoodTotal.text = '0';
    selectedStationaryTotal.text = '0';
    selectedOtherTotal.text = '0';
    selectedTotalTotal.text = '0';
    for (var element in selectedDateList) {
      selectedVisitTotal.text = (double.parse(selectedVisitTotal.text) +
              double.parse(selectedNoOfVisit[selectedDateList.indexOf(element)]
                          .text ==
                      ''
                  ? '0'
                  : selectedNoOfVisit[selectedDateList.indexOf(element)].text))
          .toString();
      selectedTravelKmTotal.text = (double.parse(selectedTravelKmTotal.text) +
              double.parse(
                  selectedTravelKm[selectedDateList.indexOf(element)].text == ''
                      ? '0'
                      : selectedTravelKm[selectedDateList.indexOf(element)]
                          .text))
          .toString();
      selectedTravelRsTotal.text = (double.parse(selectedTravelRsTotal.text) +
              double.parse(
                  selectedTravelRs[selectedDateList.indexOf(element)].text == ''
                      ? '0'
                      : selectedTravelRs[selectedDateList.indexOf(element)]
                          .text))
          .toString();
      selectedFoodTotal.text = (double.parse(selectedFoodTotal.text) +
              double.parse(
                  selectedFood[selectedDateList.indexOf(element)].text == ''
                      ? '0'
                      : selectedFood[selectedDateList.indexOf(element)].text))
          .toString();
      selectedStationaryTotal
          .text = (double.parse(selectedStationaryTotal.text) +
              double.parse(selectedStationary[selectedDateList.indexOf(element)]
                          .text ==
                      ''
                  ? '0'
                  : selectedStationary[selectedDateList.indexOf(element)].text))
          .toString();
      selectedOtherTotal.text = (double.parse(selectedOtherTotal.text) +
              double.parse(
                  selectedOther[selectedDateList.indexOf(element)].text == ''
                      ? '0'
                      : selectedOther[selectedDateList.indexOf(element)].text))
          .toString();

      selectedTotal[selectedDateList.indexOf(element)]
          .text = (double.parse(selectedTravelRs[selectedDateList.indexOf(element)].text == ''
                  ? '0'
                  : selectedTravelRs[selectedDateList.indexOf(element)].text) +
              double.parse(selectedFood[selectedDateList.indexOf(element)].text == ''
                  ? '0'
                  : selectedFood[selectedDateList.indexOf(element)].text) +
              double.parse(selectedStationary[selectedDateList.indexOf(element)].text == ''
                  ? '0'
                  : selectedStationary[selectedDateList.indexOf(element)]
                      .text) +
              double.parse(selectedOther[selectedDateList.indexOf(element)].text == ''
                  ? '0'
                  : selectedOther[selectedDateList.indexOf(element)].text) +
              double.parse(selectedTravelKm[selectedDateList.indexOf(element)].text == '' ? '0' : selectedTravelKm[selectedDateList.indexOf(element)].text) * widget.pricePerKm)
          .toString();
      selectedTotalTotal.text = (double.parse(selectedTotalTotal.text) +
              double.parse(
                  selectedTotal[selectedDateList.indexOf(element)].text == ''
                      ? '0'
                      : selectedTotal[selectedDateList.indexOf(element)].text))
          .toString();
      setState(() {});
    }
  }

  saveData() async {
    setState(() {
      isLoading = true;
    });
    var data = {
      'request_date': DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(DateTime.now().toString())),
      'user_code': constUserModel!.userCode.toString(),
    };

    int index = 0;
    // if (selectedDate.last.text.isEmpty) {
    //   selectedDateList.removeLast();
    // }

    for (var element in selectedDateList) {
      data['expense_date[$index]'] = selectedDate[index].text.toString();
      data['particulars[$index]'] = selectedParticular[index].text.toString();
      data['site_name[$index]'] = selectedNoOfVisit[index].text.toString();
      data['convey_travel[$index]'] =
          selectedTravelRs[index].text.toString() == ''
              ? '0'
              : selectedTravelRs[index].text.toString();
      data['staff_welfare[$index]'] = selectedFood[index].text.toString();
      data['misc_exp[$index]'] = '0'; // ??
      data['print_stationery[$index]'] =
          selectedStationary[index].text.toString();
      data['others_exp[$index]'] = selectedOther[index].text.toString();
      data['total_h[$index]'] = selectedTotal[index].text.toString();
      data['total_rowamt[$index]'] = '0';
      data['remark[$index]'] = selectedRemark[index].text.toString();
      data['km_travel[$index]'] = selectedTravelKm[index].text.toString();
      //  == ''
      //     ? '0'
      //     : (double.parse(selectedTravelKm[index].text) * widget.pricePerKm)
      //         .toString();
      index++;
    }

    var url = Uri.parse(reimburstmentUrl);
    var res = http.MultipartRequest(
      'POST',
      url,
    );
    Map<String, String> headers = {'Authorization': 'Bearer ${constToken!}'};

    res.headers.addAll(headers);
    if (reimburstmentFile != null) {
      var reimbustmentImg = await http.MultipartFile.fromPath(
          'reimbursement_file', reimburstmentFile!.path);
      res.files.add(reimbustmentImg);
    }

    for (var element in data.entries) {
      res.fields[element.key] = element.value;
    }
    print(res.fields);
    var response = await res.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      print(value);

      Map<String, dynamic> map = json.decode(value);

      if (map['status'] == 'success') {
        pushReplacementNavigate(context, ReimburstmentForm());
        getSnackbar(map['message'], context);
      } else {
        getSnackbar('Something went wrong. Try again later', context);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  callApi() async {
    setState(() {
      isLoading = true;
    });
    var res = await getPostCall(reimburstmentEditUrl, {
      'request_id': widget.reqId.toString(),
      'user_code': constUserModel!.userCode.toString(),
    });
    setState(() {
      isLoading = false;
    });
    var getData = json.decode(res.body);
    log(getData.toString());
    if (getData['status'] == 'success') {
      for (var element in (getData['data']['data'] as List)) {
        idList.add(element['ID'].toString());
        selectedDate[getData['data']['data'].indexOf(element)].text =
            element['EXPENSES_DATE'];

        selectedParticular[getData['data']['data'].indexOf(element)].text =
            element['PARTICULARS'];
        selectedNoOfVisit[getData['data']['data'].indexOf(element)].text =
            element['SITE_NAME'];
        selectedTravelKm[getData['data']['data'].indexOf(element)].text =
            element['KMS_TRAVEL'];
        selectedTravelRs[getData['data']['data'].indexOf(element)].text =
            element['CONVEY_TRAVEL'];
        selectedFood[getData['data']['data'].indexOf(element)].text =
            element['STAFF_WELFARE'];
        selectedStationary[getData['data']['data'].indexOf(element)].text =
            element['PRINT_STATIONERY'];
        selectedOther[getData['data']['data'].indexOf(element)].text =
            element['OTHERS_EXP'];
        selectedTotal[getData['data']['data'].indexOf(element)].text =
            element['TOTAL_ROWAMT'];
        selectedRemark[getData['data']['data'].indexOf(element)].text =
            element['REMARK'];

        fileUrl = element['UPLOAD_FILE'];
        if (getData['data']['data'].indexOf(element) + 1 ==
            getData['data']['data'].length) {
        } else {
          selectedDate.add(TextEditingController());
          selectedDateList.add(DateTime.now());
          selectedParticular.add(TextEditingController());
          selectedNoOfVisit.add(TextEditingController());
          selectedTravelKm.add(TextEditingController());
          selectedTravelRs.add(TextEditingController());
          selectedFood.add(TextEditingController());
          selectedStationary.add(TextEditingController());
          selectedOther.add(TextEditingController());
          selectedTotal.add(TextEditingController());
          selectedRemark.add(TextEditingController());
        }

//  selectedVisitTotal = TextEditingController();
//  selectedTravelKmTotal = TextEditingController();
//  selectedTravelRsTotal = TextEditingController();
//  selectedFoodTotal = TextEditingController();
//  selectedStationaryTotal = TextEditingController();
//  selectedOtherTotal = TextEditingController();
//  selectedTotalTotal = TextEditingController();
      }

      getTotal();
    }
    baseUrl = getData['data']['reimbursement_file_location'];
    setState(() {});
  }

  deleteReimburstment(int index) async {
    if (idList[index].isEmpty) {
      selectedDate.removeAt(index);
      selectedDateList.removeAt(index);
      selectedParticular.removeAt(index);
      selectedNoOfVisit.removeAt(index);
      selectedTravelKm.removeAt(index);
      selectedTravelRs.removeAt(index);
      selectedFood.removeAt(index);
      selectedStationary.removeAt(index);
      selectedOther.removeAt(index);
      selectedTotal.removeAt(index);
      selectedRemark.removeAt(index);
      return;
    }

    setState(() {
      isLoading = true;
    });
    var res = await getPostCall(reimburstmentDeleteUrl, {'id': idList[index]});
    setState(() {
      isLoading = false;
    });
    var getData = json.decode(res.body);
    if (getData['status'] == 'success') {
      selectedDate.removeAt(index);
      selectedDateList.removeAt(index);
      selectedParticular.removeAt(index);
      selectedNoOfVisit.removeAt(index);
      selectedTravelKm.removeAt(index);
      selectedTravelRs.removeAt(index);
      selectedFood.removeAt(index);
      selectedStationary.removeAt(index);
      selectedOther.removeAt(index);
      selectedTotal.removeAt(index);
      selectedRemark.removeAt(index);

      print(getData);
      getSnackbar(getData['message'], context);
    } else {
      getSnackbar('Something went wrong. Try again later', context);
    }
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
        title: getBoldText('Edit', Colors.white, 16),
      ),
      bottomSheet: Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getButton('Submit to Orgone', MyColors.primaryColor, MyColors.secondaryColor,
                () {
              saveData();
            }, getTotalWidth(context))
          ],
        ),
      ),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getBoldText('Name: ${constUserModel!.firstName}',
                            Colors.black, 16),
                        getNormalText(
                            formatDateTimeMonth(DateTime.now().toString()),
                            Colors.black,
                            16),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    getBoldText('Upload Image', Colors.black, 16),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height *
                                0.25, // Sets the height to 1/4 of the screen height
                            width: getTotalWidth(context) /
                                1, // Sets the width to the full available width
                            child: CustomPaint(
                                painter: DashedBorderPainter(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                ),
                                child: reimburstmentFile == null
                                    ? (fileUrl == null || fileUrl == '')
                                        ? Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              splashColor: Colors.white,
                                              onTap: () {
                                                showBottomSheeet(1);
                                              },
                                              child: Ink(
                                                  // alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  height: 40,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          offset: Offset(0, 1),
                                                          blurRadius: 2)
                                                    ],
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: getBoldText(
                                                        'Choose Image',
                                                        Colors.white,
                                                        14),
                                                  )),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                child: Image.network(
                                                    baseUrl + fileUrl!),
                                              ),
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  showBottomSheeet(1);
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          MyColors.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Replace',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              )
                                            ],
                                          )
                                    : Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              child: Image.file(
                                                File(reimburstmentFile!.path),
                                                // fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  showBottomSheeet(1);
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          MyColors.primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Replace',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  setState(() {
                                                    reimburstmentFile = null;
                                                  });
                                                },
                                                child: Ink(
                                                    // alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 2)
                                                      ],
                                                      color:
                                                          Colors.red.shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: getBoldText(
                                                          'Delete',
                                                          Colors.white,
                                                          14),
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                          ),
                        ],
                      ),
                    ),
                    // here
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columnSpacing: 20,
                            headingRowHeight: 35,
                            dataRowHeight: 35,
                            headingTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => MyColors.primaryColor),
                            border: TableBorder.all(
                              color: Colors.grey,
                            ),
                            columns: const [
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('Date')),
                              DataColumn(
                                label: Text('Particular'),
                              ),
                              DataColumn(label: Text('No of visit')),
                              DataColumn(label: Text('Travel(KM)')),
                              DataColumn(label: Text('Travel(Rs.)')),
                              DataColumn(label: Text('Food')),
                              DataColumn(label: Text('Stationary')),
                              DataColumn(label: Text('Others')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Remark')),
                            ],
                            rows: selectedDateList.map((e) {
                              int index = selectedDateList.indexOf(e);
                              return DataRow(cells: [
                                DataCell(GestureDetector(
                                    onTap: () {
                                      deleteReimburstment(index);

                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))),
                                DataCell(GestureDetector(
                                  onTap: () {
                                    _selectDate(context,
                                        selectedDateList[index], index);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    width: 80,
                                    height: 40,
                                    child: getNormalText(
                                        selectedDate[index].text,
                                        Colors.black,
                                        14),
                                  ),
                                )),
                                DataCell(TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: selectedParticular[index],
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedNoOfVisit[index],
                                )),
                                DataCell(TextFormField(
                                  onChanged: (value) {
                                    selectedTravelRs[index].text = '';
                                    getTotal();
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: selectedTravelKm[index],
                                )),
                                DataCell(TextFormField(
                                  onChanged: (value) {
                                    selectedTravelKm[index].text = '';
                                    getTotal();
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: selectedTravelRs[index],
                                )),
                                DataCell(TextFormField(
                                  onChanged: (value) {
                                    getTotal();
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: selectedFood[index],
                                )),
                                DataCell(TextFormField(
                                  onChanged: (value) {
                                    getTotal();
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: selectedStationary[index],
                                )),
                                DataCell(TextFormField(
                                  onChanged: (value) {
                                    getTotal();
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: selectedOther[index],
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedTotal[index],
                                )),
                                DataCell(TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: selectedRemark[index],
                                )),
                              ]);
                            }).toList()
                              ..add(DataRow(cells: [
                                DataCell(Text('')),
                                DataCell(Text('TOTAL')),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedVisitTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedTravelKmTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedTravelRsTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedFoodTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedStationaryTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedOtherTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.number,
                                  controller: selectedTotalTotal,
                                )),
                                DataCell(TextFormField(
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                )),
                              ]))

                            // [
                            //   DataRow(cells: [
                            //     DataCell(
                            //       Container(
                            //         width: 120,
                            //         height: 40,
                            //         padding: EdgeInsets.symmetric(horizontal: 10),
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(5)),
                            //         // here date picker
                            //       ),
                            //     ),
                            //     DataCell(Text(
                            //       'of',
                            //       style: TextStyle(),
                            //     )),
                            //     DataCell(Text(
                            //       '1',
                            //       style: TextStyle(),
                            //     )),
                            //     DataCell(Text(
                            //       '5%',
                            //       style: TextStyle(),
                            //     )),
                            //   ]),
                            // ]
                            )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getSmallButton('ADD EXPENCE', Colors.green, () {
                          setState(() {
                            selectedDate.add(TextEditingController());
                            selectedDateList.add(DateTime.now());
                            selectedParticular.add(TextEditingController());
                            selectedNoOfVisit.add(TextEditingController());
                            selectedTravelKm.add(TextEditingController());
                            selectedTravelRs.add(TextEditingController());
                            selectedFood.add(TextEditingController());
                            selectedStationary.add(TextEditingController());
                            selectedOther.add(TextEditingController());
                            selectedTotal.add(TextEditingController());
                            selectedRemark.add(TextEditingController());
                          });
                        }, 150)
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  showBottomSheeet(int index) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImageCameraDrawing();

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 50,
                            color: MyColors.primaryColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          getBoldText('Take a photo', Colors.black, 16)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectImageGalleryDrawing();

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_album,
                            size: 50,
                            color: MyColors.primaryColor,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          getBoldText('Import from gallery', Colors.black, 16)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
