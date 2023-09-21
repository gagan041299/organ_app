import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orgone_app/Screen/Forms/caseStatus.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionTwo.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';

import '../../Api/api.dart';

class NDMAForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const NDMAForm({super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<NDMAForm> createState() => _NDMAFormState();
}

class _NDMAFormState extends State<NDMAForm> {
  String? whatIsTheGroundTerrain;
  String? whatIsThefoundationSystem;
  String? whichTypeOfRoofing;
  String? isFirefightingSystem;
  String? isTheStrucutreInFloodProne;
  String? isSolarSystem;
  String? isMobileTowerInstalled;
  String? whichTypeOfMasonry;
  String? whichTypeOfMortar;

  List<String> whatIsTheGroundTerrainList = [
    'Levelled',
    'Undew',
    'Hill Top',
    'Hill Slope',
  ];
  List<String> whatIsThefoundationSystemList = [
    'Isolated Footing - Shallow Foundation',
    'Raft Foundation - Shallow Fondation',
    'Combined Footing - Shallow Foundation',
    'Pile Foundation - Deep Foundation',
    'Can not comment as foundation work is completed',
    'Cant comment as Construction not yet started'
  ];
  List<String> whichTypeOfRoofingList = [
    'Sloping Roof Type',
    'Flat roof Type',
    'Cant comment as Construction not yet started',
    'Desktop valuation hence not applicable'
  ];
  List<String> isFirefightingSystemList = [
    'Yes',
    'Provision made',
    'No',
    'Provision not made',
    'Manual - Editable tab',
    'External visit done hence not applicable',
    'Desktop valuation hence not applicable'
  ];
  List<String> isTheStrucutreInFloodProneList = [
    'Yes',
    'No',
    'Low Flood prone area',
    'High Flood prone area',
    'the structure is not situated in a flood prone / Riverfront area',
    'Structure Constructed within 30 M from river Bank',
    'Structure Constructed beyond 30 M from river Bank',
    'Cant comment as Construction not yet started'
  ];
  List<String> isSolarSystemList = [
    'Yes',
    'No',
    'Desktop valuation hence not applicable'
  ];
  List<String> isMobileTowerInstalledList = [
    'Yes',
    'Installed',
    'No',
    'Not installed',
    'Cant comment as Construction not yet started',
    'Desktop valuation hence not applicable'
  ];
  List<String> whichTypeOfMasonryList = [
    'Brick Masonry',
    'Rubble Masonry',
    'Hollow Block Masonry',
    'Can not comment as Building is completed',
    ' Manual - Editable tab',
    'Cant comment as Construction not yet started',
    'Desktop valuation hence not applicable'
  ];
  List<String> whichTypeOfMortarList = [
    'Cement Mortar',
    'Lime Mortar',
    'Gypsum Mortar',
    'Surkhi Mortar',
    'Mud Mortar',
    'Cant comment as building construction is completed',
    'Cant comment as Construction not yet started',
    'Desktop valuation hence not applicable'
  ];

  TextEditingController additionalCellController = TextEditingController();

  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();

  saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'ground_terrain': whatIsTheGroundTerrain ?? '',
        'foundation': whatIsThefoundationSystem ?? '',
        'roofing': whichTypeOfRoofing ?? '',
        'fire_fighting': isFirefightingSystem ?? '',
        'flood_prone': isTheStrucutreInFloodProne ?? '',
        'solar_system': isSolarSystem ?? '',
        'mobile_tower': isMobileTowerInstalled ?? '',
        'masonry': whichTypeOfMasonry ?? '',
        'mortar': whichTypeOfMortar ?? '',
        "add_cell": additionalCellController.text,
      };
      var res = await getPostCall(ndmaUrl, data);
      setState(() {
        isLoading = false;
      });
      var getData = json.decode(res.body);
      getSnackbar(getData['message'], context);
      if (getData['status'] == 'success') {
        pushNavigate(
            context, CaseStatusForm(vkid: widget.vkid, isHistoryPage: false));
      }
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
    Map<String, dynamic> data = getData['ndmaParameter'];
    try {
      whatIsTheGroundTerrain = whatIsTheGroundTerrainList.firstWhere((element) {
        return element == data['GROUND_TERRAIN'];
      }).toString();
    } catch (e) {
      whatIsTheGroundTerrain = null;
    }
    try {
      whatIsThefoundationSystem =
          whatIsThefoundationSystemList.firstWhere((element) {
        return element == data['FOUNDATION_SYSTEM'];
      }).toString();
    } catch (e) {
      whatIsThefoundationSystem = null;
    }
    try {
      whichTypeOfRoofing = whichTypeOfRoofingList.firstWhere((element) {
        return element == data['ROOFING_SYSTEM'];
      }).toString();
    } catch (e) {
      whichTypeOfRoofing = null;
    }
    try {
      isFirefightingSystem = isFirefightingSystemList.firstWhere((element) {
        return element == data['FIRE_FIGHT_SYSTEM'];
      }).toString();
    } catch (e) {
      isFirefightingSystem = null;
    }
    try {
      isTheStrucutreInFloodProne =
          isTheStrucutreInFloodProneList.firstWhere((element) {
        return element == data['FLOOD_PRONE'];
      }).toString();
    } catch (e) {
      isTheStrucutreInFloodProne = null;
    }
    try {
      isSolarSystem = isSolarSystemList.firstWhere((element) {
        return element == data['SOLAR_SYSTEM'];
      }).toString();
    } catch (e) {
      isSolarSystem = null;
    }
    try {
      isMobileTowerInstalled = isMobileTowerInstalledList.firstWhere((element) {
        return element == data['MOBILE_TOWER'];
      }).toString();
    } catch (e) {
      isMobileTowerInstalled = null;
    }
    try {
      whichTypeOfMasonry = whichTypeOfMasonryList.firstWhere((element) {
        return element == data['MASONRY_STRUCTURE'];
      }).toString();
    } catch (e) {
      whichTypeOfMasonry = null;
    }
    try {
      whichTypeOfMortar = whichTypeOfMortarList.firstWhere((element) {
        return element == data['MORTAR_USED'];
      }).toString();
    } catch (e) {
      whichTypeOfMortar = null;
    }

    try {
      additionalCellController.text = data['ADDITIONAL_CELL1'].toString();
    } catch (e) {
      additionalCellController.text = '';
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
        title: getBoldText('NDMA Form', Colors.white, 16),
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
                    PhysicalInpectionTwoForm(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBoldText('NDMA DETAILS', Colors.black, 16),
                        SizedBox(
                          height: 20,
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: whatIsTheGroundTerrain,
                          itemList: whatIsTheGroundTerrainList,
                          onChanged: (newValue) {
                            setState(() {
                              whatIsTheGroundTerrain = newValue!;
                            });
                          },
                          hint:
                              'What is the Ground terrain like? Is it the natural ground slop more than 20%?',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: whatIsThefoundationSystem,
                          itemList: whatIsThefoundationSystemList,
                          onChanged: (newValue) {
                            setState(() {
                              whatIsThefoundationSystem = newValue!;
                            });
                          },
                          hint: 'What is the foundation system and its depth',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: whichTypeOfRoofing,
                          itemList: whichTypeOfRoofingList,
                          onChanged: (newValue) {
                            setState(() {
                              whichTypeOfRoofing = newValue!;
                            });
                          },
                          hint: 'Which type of roofing system is used',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: isFirefightingSystem,
                          itemList: isFirefightingSystemList,
                          onChanged: (newValue) {
                            setState(() {
                              isFirefightingSystem = newValue!;
                            });
                          },
                          hint:
                              'Is fire fighting system/ Fire exit provision made?',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: isTheStrucutreInFloodProne,
                          itemList: isTheStrucutreInFloodProneList,
                          onChanged: (newValue) {
                            setState(() {
                              isTheStrucutreInFloodProne = newValue!;
                            });
                          },
                          hint:
                              'Is the structure situated in the flood prone/ Riverfront Area?',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: isSolarSystem,
                          itemList: isSolarSystemList,
                          onChanged: (newValue) {
                            setState(() {
                              isSolarSystem = newValue!;
                            });
                          },
                          hint: 'Is solar system provided',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: isMobileTowerInstalled,
                          itemList: isMobileTowerInstalledList,
                          onChanged: (newValue) {
                            setState(() {
                              isMobileTowerInstalled = newValue!;
                            });
                          },
                          hint: 'Is the mobile tower installed on structure',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: whichTypeOfMasonry,
                          itemList: whichTypeOfMasonryList,
                          onChanged: (newValue) {
                            setState(() {
                              whichTypeOfMasonry = newValue!;
                            });
                          },
                          hint: 'Which type of Masonry is used in the strucure',
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: whichTypeOfMortar,
                          itemList: whichTypeOfMortarList,
                          onChanged: (newValue) {
                            setState(() {
                              whichTypeOfMortar = newValue!;
                            });
                          },
                          hint: 'Which type of mortar is used?',
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Additional Cell',
                            t: additionalCellController),
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
                        //                 PhysicalInpectionTwoForm(
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
                        //                 CaseStatusForm(
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
