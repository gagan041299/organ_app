import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/api.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/customDropdownDynamicList.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/Screen/Forms/images.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import 'package:search_choices/search_choices.dart';

class TechInitiationForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const TechInitiationForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<TechInitiationForm> createState() => _TechInitiationFormState();
}

class _TechInitiationFormState extends State<TechInitiationForm> {
  TextEditingController intituteTypeController = TextEditingController();
  TextEditingController intituteNameController = TextEditingController();
  TextEditingController intituteBranchController = TextEditingController();
  TextEditingController dateOfRequestController = TextEditingController();
  TextEditingController dateOfVisitController = TextEditingController();
  TextEditingController copyCaseController = TextEditingController();
  TextEditingController nameOfApplicantController = TextEditingController();
  TextEditingController nameOfContactPersonController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController fileRefNoController = TextEditingController();
  TextEditingController casNoController = TextEditingController();
  TextEditingController addressOfPropertyAsPerRequestController =
      TextEditingController();
  TextEditingController addressOfPropertyAsPerValuedController =
      TextEditingController();
  TextEditingController cvNoController = TextEditingController();
  TextEditingController loanTypeController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController floorController = TextEditingController();
  TextEditingController socityNameController = TextEditingController();
  TextEditingController plotNoController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  TextEditingController roadController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String? selectedVal;
  String? locationType;
  List selectedValList = constDropdownList!.valuationDoneEarlier;
  List locationTypeList = constDropdownList!.locType;
  var _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  LocationData? _locationData;
  bool _isLocation = false;

  bool isLandmark = false;

  saveForm() async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      if (pincodeController.text.isNotEmpty) {
        if (pincodeController.text.length != 6) {
          getSnackbar('Enter valid pincode', context);
          return;
        }
      }

      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'flatno_unitno': flatNoController.text,
        'society_building_name': socityNameController.text,
        'floor_wing': floorController.text,
        'sector_colony_area': sectorController.text,
        'plot_no': plotNoController.text,
        'road_other': roadController.text,
        'location': locationType ?? '',
        'landmark': landmarkController.text,
        'district': districtController.text,
        // 'cts_surveyno_village': casNoController.text,
        // 'ward_name_no': '',
        // 'extra_column': '',
        'pincode': pincodeController.text,
        // 'suggested_pincode': '',
        // 'latitude': _locationData!.latitude.toString(),
        // 'longitude': _locationData!.longitude.toString(),
        'valuation_done': selectedVal ?? '',
        'cvid_past': cvNoController.text,
        'city': cityController.text,
        'created_date': formatDateTimeMonth(DateTime.now().toString()),
        'valued_addressofthe_property':
            addressOfPropertyAsPerValuedController.text,
        'request_addressofthe_property':
            addressOfPropertyAsPerRequestController.text,
      };

      var res = await getPostCall(mistechUrl, data);

      setState(() {
        isLoading = false;
      });
      print(res.body);
      var getData = json.decode(res.body);
      print(getData);
      getSnackbar(getData['message'], context);
      if (getData['status'] == 'success') {
        pushNavigate(
            context, ImagesForm(vkid: widget.vkid, isHistoryPage: false));
      }
    }
  }

  getPermission() async {
    await Location.instance.hasPermission().then((value) async {
      print(value);
      if (value == PermissionStatus.granted ||
          value == PermissionStatus.grantedLimited) {
        await Location.instance.serviceEnabled().then((element) async {
          print(element);
          if (element == true) {
            setState(() {
              _isLocation = true;
            });
            _locationData = await Location.instance.getLocation();
          } else {
            await Location.instance.requestService();
          }
        });
      } else {
        await Location.instance.requestPermission().then((value) {
          getPermission();
        });
      }
    });
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

    Map<String, dynamic> data2 = getData['dailyMissheet'];
    intituteTypeController.text = data2['INSTITUTION_TYPE'] ?? '';
    intituteNameController.text = data2['institute_name'] ?? '';
    intituteBranchController.text = data2['institute_branch'] ?? '';
    dateOfRequestController.text = data2['REQUEST_DATE'] ?? '';
    dateOfVisitController.text = data2['SCHEDULED_DATE'] ?? '';
    // copyCaseController.text = data[''];
    nameOfApplicantController.text = data2['BORROWER_NAME'] ?? '';
    nameOfContactPersonController.text = data2['CONTACT_PERSON'] ?? '';

    fileRefNoController.text = data2['FILE_REFNO'] ?? '';
    casNoController.text = data2['CAS_NO'] ?? '';
    loanTypeController.text = data2['LOAN_TYPE'] ?? '';
    if (getData['misTechinitiation'].toString() == '[]') {
      addressOfPropertyAsPerRequestController.text =
          data2['PROPERTY_ADDRESS'] ?? '';
    }
    mobileNumberController.text = data2['MOBILE_NO_1'] ?? '';
    if (data2['MOBILE_NO_2'] != null && data2['MOBILE_NO_2'] != '') {
      mobileNumberController.text += ', ${data2['MOBILE_NO_2']}';
    }
    if (data2['MOBILE_NO_3'] != null && data2['MOBILE_NO_3'] != '') {
      mobileNumberController.text += ', ${data2['MOBILE_NO_3']}';
    }

    Map<String, dynamic> data = getData['misTechinitiation'] == []
        ? {}
        : getData['misTechinitiation'][0];

    addressOfPropertyAsPerValuedController.text =
        data['VALUED_ADDRESSOFTHE_PROPERTY'] ?? '';
    cvNoController.text = data['CVID_PAST'] ?? '';
    addressOfPropertyAsPerRequestController.text =
        data['REQUEST_ADDRESSOFTHE_PROPERTY'] ?? '';
    flatNoController.text = data['FLATNO_UNITNO'] ?? '';
    floorController.text = data['FLOOR_WING'] ?? '';
    socityNameController.text = data['SOCIETY_BUILDING_NAME'] ?? '';
    plotNoController.text = data['PLOT_NO'] ?? '';
    sectorController.text = data['SECTOR_COLONY_AREA'] ?? '';
    roadController.text = data['ROAD_OTHER'] ?? '';

    cityController.text = data['CITY'] ?? '';
    districtController.text = data['DISTRICT'] ?? '';
    landmarkController.text = data['LANDMARK'] ?? '';
    pincodeController.text = data['PINCODE'] ?? '';

    landmarkController.text.isNotEmpty ? isLandmark = true : null;
    try {
      locationType = locationTypeList
          .firstWhere((element) {
            return element.id.toString() == data['LOCATION'].toString();
          })
          .name
          .toString();
    } catch (e) {
      locationType = null;
    }

    try {
      selectedVal = selectedValList
          .firstWhere((element) {
            return element.name.toString() == data['VALUATION_DONE'].toString();
          })
          .name
          .toString();
    } catch (e) {
      selectedVal = null;
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
        title: getBoldText('Tech Initiation', Colors.white, 16),
        actions: [
          IconButton(
              onPressed: () {
                pushReplacementNavigate(context, HomeScreen());
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
                pushAndRemoveUntilNavigate(context, const HomeScreen());
                return Future.delayed(Duration.zero);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Institute Type',
                            t: intituteTypeController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Institute Name',
                            t: intituteNameController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Institute Branch',
                            t: intituteBranchController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Date of Request',
                            t: dateOfRequestController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Date of Visit',
                            t: dateOfVisitController),
                        // CustomFormFiled(
                        //     setter: (val) {
                        //       setState(() {});
                        //     },
                        //     isRequired: false,
                        //     title: 'Copy Case',
                        //     t: copyCaseController),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        getBoldText('GENERAL DETAILS', Colors.black, 16),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Name of the Applicant',
                            t: nameOfApplicantController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Name of contact person',
                            t: nameOfContactPersonController),
                        CustomFormFiled(
                          setter: (val) {
                            setState(() {});
                          },
                          readOnly: true,
                          isRequired: false,
                          title: 'Mobile Number',
                          t: mobileNumberController,
                          keyboardType: TextInputType.number,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'File Ref Number',
                            t: fileRefNoController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'CAS No',
                            t: casNoController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Address Of the Property (As per request)',
                            t: addressOfPropertyAsPerRequestController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title:
                                'Address of the property (As per Inspection)',
                            t: addressOfPropertyAsPerValuedController),
                        CustomDropdownButtonDynamicList(
                            isRequired: false,
                            value: selectedVal,
                            itemList: selectedValList,
                            hint: 'Valuation done earlier',
                            onChanged: (newValue) {
                              setState(() {
                                selectedVal = newValue!;
                              });
                            }),

                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'CV No.(If yes)',
                            t: cvNoController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            readOnly: true,
                            isRequired: false,
                            title: 'Loan type/Product',
                            t: loanTypeController),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Flat No./Unit No.',
                            t: flatNoController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Floor, Wing',
                            t: floorController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Socity/ Building name',
                            t: socityNameController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Plot No.',
                            t: plotNoController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Sector/Colony/Locality',
                            t: sectorController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Road/other',
                            t: roadController),
                        CustomDropdownButtonDynamicList(
                          isRequired: false,
                          value: locationType,
                          itemList: locationTypeList,
                          onChanged: (newValue) {
                            setState(() {
                              locationType = newValue!;
                            });
                          },
                          hint: 'Location',
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'City',
                            t: cityController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'District',
                            t: districtController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {
                                val.isEmpty
                                    ? isLandmark = false
                                    : isLandmark = true;
                              });
                            },
                            isRequired: true,
                            title: 'Landmark',
                            t: landmarkController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Pincode',
                            t: pincodeController),
                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        // Container(
                        //   decoration: BoxDecoration(border: Border.all()),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(15.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         GestureDetector(
                        //           onTap: () {},
                        //           child: getNormalText(
                        //               '<< Previous Form', Colors.grey, 16),
                        //         ),
                        //         getNormalText('|', Colors.black, 16),
                        //         GestureDetector(
                        //           onTap: () {
                        //             pushAndRemoveUntilNavigate(
                        //                 context,
                        //                 ImagesForm(
                        //                   vkid: widget.vkid,
                        //                 ));
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
            ),
    );
  }
}
