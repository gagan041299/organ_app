import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/ndma.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionOne.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/customDropdownDynamicList.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';
import '../../helper/colors.dart';

class PhysicalInpectionTwoForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const PhysicalInpectionTwoForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<PhysicalInpectionTwoForm> createState() =>
      _PhysicalInpectionTwoFormState();
}

class _PhysicalInpectionTwoFormState extends State<PhysicalInpectionTwoForm> {
  String? physicalStatus;
  String? typeOfProperty;
  String? propertyUsage;
  List<String>? violationObserved;
  List<String>? commentOnCommercialUsage;
  String? forPlotWihOrWithoutSuperstruct;
  String? remarkOnViewFromProperty;
  List<String>? amenitiesAvailable;
  String? noOfWings;
  List<String>? constructionType;
  String? noOfLift;
  String? exterior;
  String? interior;
  String? kitchenPlatform;
  String? fitting;
  List<String>? flooring;
  String? window;
  String? door;
  String? maintainanceLevel;
  String? propertyAccVal;
  String? isThePropertyIndependent;

  List<dynamic> physicalStatusList = constDropdownList!.physicalStatusProperty;
  List<dynamic> typeOfPropertyList = constDropdownList!.propType;
  List<dynamic> propertyUsageList = constDropdownList!.propUsage;
  List<dynamic> violationObservedList = constDropdownList!.violation;
  List<String> commentOnCommercialUsageList = [
    'Yes',
    'No',
    'Residential Unit used as Commercial/office',
    'Residential Unit used Partly used as Commercial/office',
    'Service Industrial used as Office',
    'Garage used as Commerical Unit',
    'Garage used as Residential Unit',
    'Residential Plot used for Commerical Activity',
    'Desktop valuation hence not applicable',
    'External visit done hence not applicabl'
  ];
  List<dynamic> forPlotWihOrWithoutSuperstructList =
      constDropdownList!.plotDemarcated;
  List<dynamic> remarkOnViewFromPropertyList =
      constDropdownList!.remarksProperty;
  List<dynamic> amenitiesAvailableList =
      constDropdownList!.amenitiesAvailableSociety;
  List<dynamic> noOfWingsList = constDropdownList!.noWingsSociety;
  List<dynamic> constructionTypeList = constDropdownList!.constructionType;
  List<dynamic> noOfLiftList = constDropdownList!.noOfLifts;
  List<dynamic> exteriorList = constDropdownList!.exterior;
  List<dynamic> interiorList = constDropdownList!.interior;
  List<String> kitchenPlatformList = [
    'Granite',
    'Marble',
    'Glass',
    'Concrete',
    'Kota Stone',
    'Desktop valuation hence not applicable',
    'Not Applicable',
    'Property Under Construction',
    'Property under Renovation',
    'External visit done hence not applicable',
  ];
  List<dynamic> fittingList = constDropdownList!.fittings;
  List<dynamic> flooringList = constDropdownList!.flooring;
  List<dynamic> windowList = constDropdownList!.window;
  List<dynamic> doorList = constDropdownList!.doors;
  List<dynamic> maintainanceLevelList = constDropdownList!.maintenanceLevel;
  List<String> propertyAccValList = [
    '1RK',
    '1BR',
    '2BR',
    '3BR',
    '4BR',
    '5BR',
    'OFF',
    'PEN',
    'PLT',
    'SHP',
  ];
  List<dynamic> isThePropertyIndependentList =
      constDropdownList!.independentAccess;

  List<MultiSelectItem> commentOnCommercialUsageMultiList = [];
  List<MultiSelectItem> voilationObservedMultiList = [];
  List<MultiSelectItem> amenitiesAvailableMultiList = [];
  List<MultiSelectItem> constructionTypeMultiList = [];
  List<MultiSelectItem> flooringMultiList = [];

  TextEditingController percentageOfConstructionController =
      TextEditingController();
  TextEditingController forUnderConstructionController =
      TextEditingController();
  TextEditingController inCaseOfMergedPropertiesController =
      TextEditingController();
  TextEditingController floorNumberInCaseOfIndependentController =
      TextEditingController();
  TextEditingController noOfUnitPerFloorController = TextEditingController();
  TextEditingController accomodationOfUnitController = TextEditingController();
  TextEditingController anyOtherDetailController = TextEditingController();
  TextEditingController noOfStoreysController = TextEditingController();
  TextEditingController floorTofloorHeightController = TextEditingController();
  TextEditingController propertyAgeController = TextEditingController();
  TextEditingController carpetAreaController = TextEditingController();
  TextEditingController ratePerSqFtController = TextEditingController();
  TextEditingController noOfCarParkedController = TextEditingController();
  TextEditingController rentalPerMonthController = TextEditingController();
  TextEditingController engineerRmeakrController = TextEditingController();

  //Data for table

  List<String> footingList = ['Not Started', 'In Progress', 'Completed'];
  List<String> plinthList = ['Not Started', 'In Progress', 'Completed'];
  List<String> liftIntallationList = [
    'Installed',
    'Partially Installed',
    'Not Installed',
    'Not Applicable'
  ];

  String footing = 'Not Started';
  String plinth = 'Not Started';
  String liftInstallation = 'Installed';

  TextEditingController rccSlabCompletedController = TextEditingController();
  TextEditingController rccSlabTotalController = TextEditingController();

  TextEditingController externalBrickWorkCompletedController =
      TextEditingController();
  TextEditingController externalBrickWorkTotalController =
      TextEditingController();

  TextEditingController internalBrickWorkCompletedController =
      TextEditingController();
  TextEditingController internalBrickWorkTotalController =
      TextEditingController();

  TextEditingController internalPlasterCompletedController =
      TextEditingController();
  TextEditingController internalPlasterTotalController =
      TextEditingController();
  TextEditingController externalPlasterCompletedController =
      TextEditingController();
  TextEditingController externalPlasterTotalController =
      TextEditingController();
  TextEditingController flooringCompletedController = TextEditingController();
  TextEditingController flooringTotalController = TextEditingController();
  TextEditingController gypsumAndPaintingCompletedController =
      TextEditingController();
  TextEditingController gypsumAndPaintingTotalController =
      TextEditingController();
  TextEditingController plumbingAndElectricFittingCompletedController =
      TextEditingController();
  TextEditingController plumbingAndElectricFittingTotalController =
      TextEditingController();

  TextEditingController liftInstalationTotalController =
      TextEditingController();

  List<TextEditingController> tableDateControllerList = [];

  List<TextEditingController> tableStageControllerList = [];

  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();

  LocationData? _locationData;
  bool _isLocation = false;

  List<Map<String, dynamic>> list = [];

  bool showCompuation = false;

  var physicalStatusKey = GlobalKey();
  var maintainanceLevelKey = GlobalKey();
  var typeOfPropertyKey = GlobalKey();
  var propertyUsageKey = GlobalKey();
  var violationObservedKey = GlobalKey();
  var commentOnCommercialUsageKey = GlobalKey();
  var remarkOnViewFromPropertyKey = GlobalKey();
  var noOfWingsKey = GlobalKey();
  var constructionTypeKey = GlobalKey();
  var noOfLiftKey = GlobalKey();
  var exteriorKey = GlobalKey();
  var interiorKey = GlobalKey();
  var fittingKey = GlobalKey();
  var windowKey = GlobalKey();
  var doorKey = GlobalKey();
  var forPlotWihOrWithoutSuperstructKey = GlobalKey();
  var amenitiesAvailableKey = GlobalKey();
  var flooringKey = GlobalKey();

  saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (physicalStatus == null) {
        Scrollable.ensureVisible(physicalStatusKey.currentContext!);
        getSnackbar('Physical Status of Project is required', context);
        return;
      }
      if (typeOfProperty == null) {
        Scrollable.ensureVisible(typeOfPropertyKey.currentContext!);
        getSnackbar('Property Type is required', context);
        return;
      }
      if (propertyUsage == null) {
        Scrollable.ensureVisible(propertyUsageKey.currentContext!);
        getSnackbar('Property usage is required', context);
        return;
      }
      if (violationObserved == null) {
        Scrollable.ensureVisible(violationObservedKey.currentContext!);
        getSnackbar('Violation Observed is required', context);
        return;
      }
      if (commentOnCommercialUsage == null) {
        Scrollable.ensureVisible(commentOnCommercialUsageKey.currentContext!);
        getSnackbar('Comment on Commercial Usage is required', context);
        return;
      }
      // if (forPlotWihOrWithoutSuperstruct == null) {
      //   Scrollable.ensureVisible(
      //       forPlotWihOrWithoutSuperstructKey.currentContext!);
      //   getSnackbar(
      //       'For Plots with or Without superstructure- Comment on Demarcation By is required',
      //       context);
      //   return;
      // }
      if (remarkOnViewFromProperty == null) {
        Scrollable.ensureVisible(remarkOnViewFromPropertyKey.currentContext!);
        getSnackbar('Remarks on view from property is required', context);
        return;
      }
      if (amenitiesAvailable == null) {
        Scrollable.ensureVisible(amenitiesAvailableKey.currentContext!);
        getSnackbar('Amenities Available in Society is required', context);
        return;
      }
      if (noOfWings == null) {
        Scrollable.ensureVisible(noOfWingsKey.currentContext!);
        getSnackbar('No of Wings in Society is required', context);
        return;
      }
      if (constructionType == null) {
        Scrollable.ensureVisible(constructionTypeKey.currentContext!);
        getSnackbar('Construction Type is required', context);
        return;
      }
      if (noOfLift == null) {
        Scrollable.ensureVisible(noOfLiftKey.currentContext!);
        getSnackbar('No Of Lifts is required', context);
        return;
      }
      if (exterior == null) {
        Scrollable.ensureVisible(exteriorKey.currentContext!);
        getSnackbar('Exterior is required', context);
        return;
      }
      if (interior == null) {
        Scrollable.ensureVisible(interiorKey.currentContext!);
        getSnackbar('Interior is required', context);
        return;
      }
      if (fitting == null) {
        Scrollable.ensureVisible(fittingKey.currentContext!);
        getSnackbar('Fitting is required', context);
        return;
      }
      if (flooring == null) {
        Scrollable.ensureVisible(flooringKey.currentContext!);
        getSnackbar('Flooring is required', context);
        return;
      }
      if (window == null) {
        Scrollable.ensureVisible(windowKey.currentContext!);
        getSnackbar('Window is required', context);
        return;
      }
      if (door == null) {
        Scrollable.ensureVisible(doorKey.currentContext!);
        getSnackbar('Door is required', context);
        return;
      }
      if (maintainanceLevel == null) {
        Scrollable.ensureVisible(maintainanceLevelKey.currentContext!);
        getSnackbar(
            'Maintenance Level of Society/Project is required', context);
        return;
      }
      setState(() {
        isLoading = true;
      });

      String ccu = '';
      String vo = '';
      String aas = '';
      String ct = '';
      String fl = '';

      String propUsageId = '';
      String propTypeId = '';

      if (propertyUsage != null) {
        try {
          propUsageId = propertyUsageList
              .firstWhere((element) {
                return element.name.toString() == propertyUsage.toString();
              })
              .id
              .toString();
        } catch (e) {
          // propertyUsage = null;
        }
      }
      if (typeOfProperty != null) {
        try {
          propTypeId = typeOfPropertyList
              .firstWhere((element) {
                return element.name.toString() == typeOfProperty.toString();
              })
              .id
              .toString();
        } catch (e) {
          // propertyUsage = null;
        }
      }

      if (commentOnCommercialUsage != null) {
        commentOnCommercialUsage!.forEach((element) {
          ccu = ccu + element + ',';
        });
      }
      if (violationObserved != null) {
        violationObserved!.forEach((element) {
          vo = vo + element + ',';
        });
      }
      if (amenitiesAvailable != null) {
        amenitiesAvailable!.forEach((element) {
          aas = aas + element + ',';
        });
      }
      if (constructionType != null) {
        constructionType!.forEach((element) {
          ct = ct + element + ',';
        });
      }
      if (flooring != null) {
        flooring!.forEach((element) {
          fl = fl + element + ',';
        });
      }
      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'created_date': formatDateTimeMonth(DateTime.now().toString()),
        'property_status': physicalStatus ?? '',
        'name_reported_owner': '',
        'property_type': propTypeId,
        'property_usage': propUsageId,
        'construction_plan_details': '',
        'violation_observed': vo,
        'commercial_usage_details': ccu,
        'independent_unit_access': isThePropertyIndependent ?? '',
        'site_plot_demarcated': forPlotWihOrWithoutSuperstruct ?? '',
        'floor_incase_independent_unit':
            floorNumberInCaseOfIndependentController.text,
        'units_floor_position': noOfUnitPerFloorController.text,
        'property_view_remarks': remarkOnViewFromProperty ?? '',
        'property_accommodation': accomodationOfUnitController.text,
        'property_acc_value_hdfc': propertyAccVal ?? '',
        'available_amenities': aas,
        'construction_type': ct,
        'wings_number_society': noOfWings,
        'no_of_storeys': noOfStoreysController.text,
        'no_of_floors': floorTofloorHeightController.text,
        'no_of_lifts': noOfLift,
        'other_upper_floor_accommodation': anyOtherDetailController.text,
        'exterior': exterior,
        'interior': interior ?? '',
        'floorings': fl,
        'factors_valuation': '',
        'fittings': fitting ?? '',
        'door': door ?? '',
        'window': window ?? '',
        'maintenance_level': maintainanceLevel ?? ' ',
        'property_age': propertyAgeController.text,
        'residual_age': '',
        'carpet_area_measured': carpetAreaController.text,
        'rate_per_sqft': ratePerSqFtController.text,
        'no_car_park': noOfCarParkedController.text,
        'rental_per_month': rentalPerMonthController.text,
        'engineers_remark': engineerRmeakrController.text,
        'detail_ofconstruction': computeController.text,
        'stage_cal': percentageOfConstructionController.text,
        'under_construction': ' ',
        'floor_to_floor': '',
        'kitchen_platform': kitchenPlatform ?? ' ',
        'case_merged': inCaseOfMergedPropertiesController.text,
      };

      int totalTableRow = 11;
      for (int i = 0; i < totalTableRow; i++) {
        if (i == 0) {
          data['construction[$i]'] = 'Footing/Excavation';
          data['completed[$i]'] = footing;
          data['total[$i]'] = '1';
          data['weightage[$i]'] = '5';
        } else if (i == 1) {
          data['construction[$i]'] = 'Plinth';
          data['completed[$i]'] = plinth;
          data['total[$i]'] = '1';
          data['weightage[$i]'] = '5';
        } else if (i == 2) {
          data['construction[$i]'] = 'RCC Slabs';
          data['completed[$i]'] = rccSlabCompletedController.text;
          data['total[$i]'] = rccSlabTotalController.text;
          data['weightage[$i]'] = '40';
        } else if (i == 3) {
          data['construction[$i]'] = 'External Brick Work';
          data['completed[$i]'] = externalBrickWorkCompletedController.text;
          data['total[$i]'] = externalBrickWorkTotalController.text;
          data['weightage[$i]'] = '7.5';
        } else if (i == 4) {
          data['construction[$i]'] = 'Internal Brick Work';
          data['completed[$i]'] = internalBrickWorkCompletedController.text;
          data['total[$i]'] = internalBrickWorkTotalController.text;
          data['weightage[$i]'] = '7.5';
        } else if (i == 5) {
          data['construction[$i]'] = 'Internal Plaster';
          data['completed[$i]'] = internalPlasterCompletedController.text;
          data['total[$i]'] = internalPlasterTotalController.text;
          data['weightage[$i]'] = '5';
        } else if (i == 6) {
          data['construction[$i]'] = 'External Plaster';
          data['completed[$i]'] = externalPlasterCompletedController.text;
          data['total[$i]'] = externalPlasterTotalController.text;
          data['weightage[$i]'] = '5';
        } else if (i == 7) {
          data['construction[$i]'] = 'Flooring';
          data['completed[$i]'] = flooringCompletedController.text;
          data['total[$i]'] = flooringTotalController.text;
          data['weightage[$i]'] = '10';
        } else if (i == 8) {
          data['construction[$i]'] = 'Gypsum and Painting';
          data['completed[$i]'] = gypsumAndPaintingCompletedController.text;
          data['total[$i]'] = gypsumAndPaintingTotalController.text;
          data['weightage[$i]'] = '5';
        } else if (i == 9) {
          data['construction[$i]'] = 'Plumbing and Electric Fitting';
          data['completed[$i]'] =
              plumbingAndElectricFittingCompletedController.text;
          data['total[$i]'] = plumbingAndElectricFittingTotalController.text;
          data['weightage[$i]'] = '5';
        } else if (i == 10) {
          data['construction[$i]'] = 'Lift Installation';
          data['completed[$i]'] = liftInstallation;
          data['total[$i]'] = liftInstalationTotalController.text;
          data['weightage[$i]'] = '5';
        }
      }
      if (list.isNotEmpty) {
        list.forEach((element) {
          data['visit_date[${list.indexOf(element)}]'] =
              tableDateControllerList[list.indexOf(element)].text;
          data['per_stage[${list.indexOf(element)}]'] =
              tableStageControllerList[list.indexOf(element)].text;
        });
      }
      log(data.toString());
      var res = await getPostCall(physicalInspectionTwoUrl, data);
      print(res.body);
      setState(() {
        isLoading = false;
      });
      var getData = json.decode(res.body);
      getSnackbar(getData['message'], context);
      if (getData['status'] == 'success') {
        pushNavigate(
            context, NDMAForm(vkid: widget.vkid, isHistoryPage: false));
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
    Map<String, dynamic> data = getData['physicalInspection2'];
    List<dynamic> firstTabledata = getData['detailsofConstruction'];
    List<dynamic> secondTabledata = getData['stageAnalogue'];

    if (firstTabledata.isNotEmpty) {
      for (var element in firstTabledata) {
        if (element['CONSTRUCTION'] == 'Footing/Excavation') {
          footing = element['COMPLETED'];
        } else if (element['CONSTRUCTION'] == 'Plinth') {
          plinth = element['COMPLETED'];
        } else if (element['CONSTRUCTION'] == 'RCC Slabs') {
          rccSlabCompletedController.text = element['COMPLETED'] == null
              ? ''
              : element['COMPLETED'].toString();
          rccSlabTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'External Brick Work') {
          externalBrickWorkCompletedController.text =
              element['COMPLETED'] == null
                  ? ''
                  : element['COMPLETED'].toString();
          externalBrickWorkTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Internal Brick Work') {
          internalBrickWorkCompletedController.text =
              element['COMPLETED'] == null
                  ? ''
                  : element['COMPLETED'].toString();
          internalBrickWorkTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Internal Plaster') {
          internalPlasterCompletedController.text = element['COMPLETED'] == null
              ? ''
              : element['COMPLETED'].toString();
          internalPlasterTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'External Plaster') {
          externalPlasterCompletedController.text = element['COMPLETED'] == null
              ? ''
              : element['COMPLETED'].toString();
          externalPlasterTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Flooring') {
          flooringCompletedController.text = element['COMPLETED'] == null
              ? ''
              : element['COMPLETED'].toString();
          flooringTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Gypsum and Painting') {
          gypsumAndPaintingCompletedController.text =
              element['COMPLETED'] == null
                  ? ''
                  : element['COMPLETED'].toString();
          gypsumAndPaintingTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Plumbing and Electric Fitting') {
          plumbingAndElectricFittingCompletedController.text =
              element['COMPLETED'] == null
                  ? ''
                  : element['COMPLETED'].toString();
          plumbingAndElectricFittingTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        } else if (element['CONSTRUCTION'] == 'Lift Installation') {
          print('HH');
          print(element['TOTAL']);
          liftInstallation = element['COMPLETED'];
          liftInstalationTotalController.text =
              element['TOTAL'] == null ? '' : element['TOTAL'].toString();
        }
      }
    }

    if (secondTabledata.isNotEmpty) {
      secondTabledata.forEach((element) {
        list.add({
          'dateOfVisit': element['VISIT_DATE'].toString(),
          'stage': element['PER_STAGE'].toString(),
        });
        tableDateControllerList
            .add(TextEditingController(text: element['VISIT_DATE'].toString()));
        tableStageControllerList
            .add(TextEditingController(text: element['PER_STAGE'].toString()));
      });
    }

    print(data);
    try {
      physicalStatus = physicalStatusList
          .firstWhere((element) {
            return element.name.toString() ==
                data['PROPERTY_STATUS'].toString();
          })
          .name
          .toString();
    } catch (e) {
      physicalStatus = null;
    }
    try {
      percentageOfConstructionController.text = data['STAGE_CAL'].toString();
    } catch (e) {
      percentageOfConstructionController.text = '';
    }

    // try {
    //   forUnderConstructionController.text = data['STAGE_CAL'].toString();
    // } catch (e) {
    //   percentageOfConstructionController.text = '';
    // }

    try {
      typeOfProperty = typeOfPropertyList
          .firstWhere((element) {
            return element.id.toString() == data['PROPERTY_TYPE'].toString();
          })
          .name
          .toString();
    } catch (e) {
      typeOfProperty = null;
    }

    try {
      propertyUsage = propertyUsageList
          .firstWhere((element) {
            return element.id.toString() == data['PROPERTY_USAGE'].toString();
          })
          .name
          .toString();
    } catch (e) {
      propertyUsage = null;
    }

    try {
      violationObserved = data['VIOLATION_OBSERVED'].split(',');
    } catch (e) {
      violationObserved = null;
    }

    try {
      computeController.text = data['DETAIL_OFCONSTRUCTION'];
    } catch (e) {
      computeController.text = '';
    }

    try {
      inCaseOfMergedPropertiesController.text = data['MERGED_PROPERTY'] != null
          ? data['MERGED_PROPERTY'].toString()
          : '';
    } catch (e) {
      inCaseOfMergedPropertiesController.text = '';
    }

    try {
      commentOnCommercialUsage = data['COMMERCIAL_USAGE_DETAILS'].split(',');
    } catch (e) {
      commentOnCommercialUsage = null;
    }

    try {
      floorNumberInCaseOfIndependentController.text =
          data['FLOOR_INCASE_INDEPENDENT_UNIT'].toString();
    } catch (e) {
      floorNumberInCaseOfIndependentController.text = '';
    }

    try {
      forPlotWihOrWithoutSuperstruct = forPlotWihOrWithoutSuperstructList
          .firstWhere((element) {
            return element.name.toString() ==
                data['SITE_PLOT_DEMARCATED'].toString();
          })
          .name
          .toString();
    } catch (e) {
      forPlotWihOrWithoutSuperstruct = null;
    }

    try {
      remarkOnViewFromProperty = remarkOnViewFromPropertyList
          .firstWhere((element) {
            return element.name.toString() ==
                data['PROPERTY_VIEW_REMARKS'].toString();
          })
          .name
          .toString();
    } catch (e) {
      remarkOnViewFromProperty = null;
    }

    try {
      noOfUnitPerFloorController.text = data['UNITS_FLOOR_POSITION'].toString();
    } catch (e) {
      noOfUnitPerFloorController.text = '';
    }

    try {
      amenitiesAvailable = data['AVAILABLE_AMENITIES'].split(',');
    } catch (e) {
      amenitiesAvailable = null;
    }

    try {
      accomodationOfUnitController.text =
          data['PROPERTY_ACCOMMODATION'].toString();
    } catch (e) {
      accomodationOfUnitController.text = '';
    }

    try {
      noOfWings = noOfWingsList
          .firstWhere((element) {
            return element.name.toString() ==
                data['WINGS_NUMBER_SOCIETY'].toString();
          })
          .name
          .toString();
    } catch (e) {
      noOfWings = null;
    }

    try {
      constructionType = data['CONSTRUCTION_TYPE'].split(',');
    } catch (e) {
      constructionType = null;
    }

    try {
      anyOtherDetailController.text =
          data['OTHER_UPPER_FLOOR_ACCOMMODATION'].toString();
    } catch (e) {
      anyOtherDetailController.text = '';
    }

    try {
      noOfStoreysController.text = data['NO_OF_STOREYS'].toString();
    } catch (e) {
      noOfStoreysController.text = '';
    }

    //try {
    //   floorTofloorHeightController.text = data['NO_OF_FLOORS'].toString();
    // } catch (e) {
    //   floorTofloorHeightController.text = '';
    // }

    try {
      noOfLift = noOfLiftList
          .firstWhere((element) {
            return element.name.toString() == data['NO_OF_LIFTS'].toString();
          })
          .name
          .toString();
    } catch (e) {
      noOfLift = null;
    }

    try {
      print(exteriorList[0].name);
      exterior = exteriorList
          .firstWhere((element) {
            String one = element.name.replaceAll(' ', '');
            String two = data['EXTERIOR'].replaceAll(' ', '');
            return one.toString() == two.toString();
          })
          .name
          .toString();
    } catch (e) {
      exterior = null;
    }
    try {
      interior = interiorList
          .firstWhere((element) {
            String one = element.name.replaceAll(' ', '');
            String two = data['INTERIOR'].replaceAll(' ', '');
            return one.toString() == two.toString();
          })
          .name
          .toString();
    } catch (e) {
      interior = null;
    }

    try {
      kitchenPlatform = kitchenPlatformList.firstWhere((element) {
        return element == data['KITCHEN_PLATFORM'];
      }).toString();
    } catch (e) {
      kitchenPlatform = null;
    }
    try {
      fitting = fittingList
          .firstWhere((element) {
            return element.name.toString() == data['FITTINGS'].toString();
          })
          .name
          .toString();
    } catch (e) {
      fitting = null;
    }

    try {
      flooring = data['FLOORINGS'].split(',');
    } catch (e) {
      flooring = null;
    }
    try {
      window = windowList
          .firstWhere((element) {
            return element.name.toString() == data['WINDOW'].toString();
          })
          .name
          .toString();
    } catch (e) {
      window = null;
    }
    try {
      door = doorList
          .firstWhere((element) {
            return element.name.toString() == data['DOOR'].toString();
          })
          .name
          .toString();
    } catch (e) {
      door = null;
    }

    try {
      floorTofloorHeightController.text = data['NO_OF_FLOORS'].toString();
    } catch (e) {
      floorTofloorHeightController.text = '';
    }

    try {
      propertyAgeController.text = data['PROPERTY_AGE'].toString();
    } catch (e) {
      propertyAgeController.text = '';
    }

    try {
      maintainanceLevel = maintainanceLevelList
          .firstWhere((element) {
            return element.name.toString() ==
                data['MAINTENANCE_LEVEL'].toString();
          })
          .name
          .toString();
    } catch (e) {
      maintainanceLevel = null;
    }
    try {
      propertyAccVal = propertyAccValList.firstWhere((element) {
        return element == data['PROPERTY_ACC_VALUE_HDFC'];
      }).toString();
    } catch (e) {
      propertyAccVal = null;
    }

    try {
      isThePropertyIndependent = isThePropertyIndependentList
          .firstWhere((element) {
            return element.name == data['INDEPENDENT_UNIT_ACCESS'];
          })
          .name
          .toString();
    } catch (e) {
      isThePropertyIndependent = null;
    }

    try {
      carpetAreaController.text = data['CARPET_AREA_MEASURED'].toString();
    } catch (e) {
      carpetAreaController.text = '';
    }
    try {
      ratePerSqFtController.text = data['RATE_PER_SQFT'].toString();
    } catch (e) {
      ratePerSqFtController.text = '';
    }
    try {
      noOfCarParkedController.text = data['NO_CAR_PARK'].toString();
    } catch (e) {
      noOfCarParkedController.text = '';
    }
    try {
      rentalPerMonthController.text = data['RENTAL_PER_MONTH'].toString();
    } catch (e) {
      rentalPerMonthController.text = '';
    }
    try {
      engineerRmeakrController.text = data['ENGINEERS_REMARK'].toString();
    } catch (e) {
      engineerRmeakrController.text = '';
    }

    setState(() {});

    print(data);
  }

  List<DateTime> selectedDates = [];

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        tableDateControllerList[index].text =
            formatDateTimeMonth(picked.toString());
      });
    }
  }

  TextEditingController computeController = TextEditingController();

  @override
  void initState() {
    commentOnCommercialUsageMultiList = commentOnCommercialUsageList
        .map((val) => MultiSelectItem<String>(val, val))
        .toList();
    voilationObservedMultiList = violationObservedList
        .map((val) => MultiSelectItem<String>(val.name, val.name))
        .toList();
    amenitiesAvailableMultiList = amenitiesAvailableList
        .map((val) => MultiSelectItem<String>(val.name, val.name))
        .toList();
    constructionTypeMultiList = constructionTypeList
        .map((val) => MultiSelectItem<String>(val.name, val.name))
        .toList();
    flooringMultiList = flooringList
        .map((val) => MultiSelectItem<String>(val.name, val.name))
        .toList();

    // list.add({
    //   'dateOfVisit': tableDateControllerList[0].text,
    //   'stage': tableStageControllerList[0].text
    // });

    getInitialData();
    super.initState();
  }

  computeData() {
    percentWorkDone = 0;
    if (footing == 'Completed') {
      percentWorkDone += 5;
    }
    if (plinth == 'Completed') {
      percentWorkDone += 5;
    }
    //for rcc
    // percentWorkDone += (40 /
    //         double.parse(rccSlabTotalController.text == ''
    //             ? '1'
    //             : rccSlabTotalController.text)) *
    //     double.parse(rccSlabCompletedController.text == ''
    //         ? '0'
    //         : rccSlabCompletedController.text);
    (rccSlabTotalController.text.isEmpty ||
            rccSlabCompletedController.text.isEmpty ||
            rccSlabTotalController.text == '0')
        ? 0
        : percentWorkDone += (40 / double.parse(rccSlabTotalController.text)) *
            double.parse(rccSlabCompletedController.text);
    (externalBrickWorkTotalController.text.isEmpty ||
            externalBrickWorkCompletedController.text.isEmpty ||
            externalBrickWorkTotalController.text == '0')
        ? 0
        : percentWorkDone +=
            (7.5 / double.parse(externalBrickWorkTotalController.text)) *
                double.parse(externalBrickWorkCompletedController.text);
    (internalBrickWorkTotalController.text.isEmpty ||
            internalBrickWorkCompletedController.text.isEmpty ||
            internalBrickWorkTotalController.text == '0')
        ? 0
        : percentWorkDone +=
            (7.5 / double.parse(internalBrickWorkTotalController.text)) *
                double.parse(internalBrickWorkCompletedController.text);
    (internalPlasterTotalController.text.isEmpty ||
            internalPlasterCompletedController.text.isEmpty ||
            internalPlasterTotalController.text == '0')
        ? 0
        : percentWorkDone +=
            (5 / double.parse(internalPlasterTotalController.text)) *
                double.parse(internalPlasterCompletedController.text);
    (externalPlasterTotalController.text.isEmpty ||
            externalPlasterCompletedController.text.isEmpty ||
            externalPlasterTotalController.text == '0')
        ? 0
        : percentWorkDone +=
            (5 / double.parse(externalPlasterTotalController.text)) *
                double.parse(externalPlasterCompletedController.text);
    (flooringTotalController.text.isEmpty ||
            flooringCompletedController.text.isEmpty ||
            flooringTotalController.text == '0')
        ? 0
        : percentWorkDone += (10 / double.parse(flooringTotalController.text)) *
            double.parse(flooringCompletedController.text);
    (gypsumAndPaintingTotalController.text.isEmpty ||
            gypsumAndPaintingCompletedController.text.isEmpty ||
            gypsumAndPaintingTotalController.text == '0')
        ? 0
        : percentWorkDone +=
            (5 / double.parse(gypsumAndPaintingTotalController.text)) *
                double.parse(gypsumAndPaintingCompletedController.text);
    (plumbingAndElectricFittingTotalController.text.isEmpty ||
            plumbingAndElectricFittingCompletedController.text.isEmpty ||
            plumbingAndElectricFittingTotalController.text == '0')
        ? 0
        : percentWorkDone += (5 /
                double.parse(plumbingAndElectricFittingTotalController.text)) *
            double.parse(plumbingAndElectricFittingCompletedController.text);

    if (liftInstallation != 'Not Installed') {
      (liftInstalationTotalController.text.isEmpty ||
              liftInstalationTotalController.text == '0')
          ? 0
          : percentWorkDone +=
              (5 / double.parse(liftInstalationTotalController.text));
      //
    }
    print(percentWorkDone);
    percentageOfConstructionController.text =
        percentWorkDone.round().toString();
  }

// (weightage/total)*completed
  double percentWorkDone = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getBoldText('Physical Inspection Two', Colors.white, 16),
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
                    PhysicalInpectionOneForm(
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
                        getBoldText(
                            'DETAIL OF PROPERTY LOCATION', Colors.black, 16),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          key: physicalStatusKey,
                          child: CustomDropdownButtonDynamicList(
                            value: physicalStatus,
                            itemList: physicalStatusList,
                            onChanged: (newValue) {
                              setState(() {
                                physicalStatus = newValue!;
                              });
                              if (physicalStatus == 'Completed and Occupied') {
                                percentageOfConstructionController.text =
                                    '100%';
                              }
                            },
                            hint: 'Physical status of project',
                          ),
                        ),
                        (physicalStatus ==
                                    'Under Construction Work not in Progress' ||
                                physicalStatus ==
                                    'Under Construction Work in Progress')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getBoldText('Details of Constructions',
                                          Colors.black, 16),
                                      getSmallButton('Compute', Colors.blue,
                                          () {
                                        setState(() {
                                          showCompuation = true;
                                        });
                                        computeController.text =
                                            'Footing/Excavation: $footing, Plinth: $plinth, RCC Slabes: ${rccSlabCompletedController.text}, External Brick Work: ${externalBrickWorkCompletedController.text}, Internal Brick Work: ${internalBrickWorkCompletedController.text}, Internal Plaster: ${internalPlasterCompletedController.text}, External Plaster: ${externalPlasterCompletedController.text}, Flooring: ${flooringCompletedController.text}, Gypsum and Painting ${gypsumAndPaintingCompletedController.text}, Plumbing and Electric Fitting ${plumbingAndElectricFittingCompletedController.text}, Lift Installation: $liftInstallation ';
                                        setState(() {});
                                        computeData();
                                      }, getTotalWidth(context) / 4)
                                    ],
                                  ),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    MyColors.primaryColor),
                                        border: TableBorder.all(
                                          color: Colors.grey,
                                        ),
                                        columns: [
                                          const DataColumn(
                                              label: Text('Construction')),
                                          const DataColumn(
                                            label: Text('Completed'),
                                          ),
                                          const DataColumn(label: Text('of')),
                                          const DataColumn(
                                              label: Text('Total')),
                                          const DataColumn(
                                              label: Text('Weightage')),
                                        ],
                                        rows: [
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Footing/Excavation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(
                                              Container(
                                                width: 120,
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: DropdownButton<String>(
                                                  itemHeight: 60,
                                                  elevation: 0,
                                                  value: footing,
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  ),
                                                  items: footingList
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      footing = val!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(Text(
                                              '1',
                                              style: TextStyle(),
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Plinth',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(
                                              Container(
                                                width: 120,
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: DropdownButton<String>(
                                                  itemHeight: 60,
                                                  elevation: 0,
                                                  value: plinth,
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  ),
                                                  items: plinthList
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      plinth = val!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(Text(
                                              '1',
                                              style: TextStyle(),
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'RCC Slabs',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  rccSlabCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  rccSlabTotalController,
                                            )),
                                            DataCell(Text(
                                              '40%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'External Brick Work',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  externalBrickWorkCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              onChanged: (value) {
                                                internalBrickWorkTotalController
                                                    .text = value;
                                                internalPlasterTotalController
                                                    .text = value;
                                                externalPlasterTotalController
                                                    .text = value;
                                                flooringTotalController.text =
                                                    value;
                                                gypsumAndPaintingTotalController
                                                    .text = value;
                                                plumbingAndElectricFittingTotalController
                                                    .text = value;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  externalBrickWorkTotalController,
                                            )),
                                            DataCell(Text(
                                              '7.5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Internal Brick Work',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  internalBrickWorkCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  internalBrickWorkTotalController,
                                            )),
                                            DataCell(Text(
                                              '7.5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Internal Plaster',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  internalPlasterCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  internalPlasterTotalController,
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'External Plaster',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  externalPlasterCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  externalPlasterTotalController,
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Flooring',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  flooringCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  flooringTotalController,
                                            )),
                                            DataCell(Text(
                                              '10%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Gypsum and Painting',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  gypsumAndPaintingCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  gypsumAndPaintingTotalController,
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Plumbing and Electric Fitting',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  plumbingAndElectricFittingCompletedController,
                                            )),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  plumbingAndElectricFittingTotalController,
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text(
                                              'Lift Installation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            )),
                                            DataCell(
                                              Container(
                                                width: 120,
                                                height: 40,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: DropdownButton<String>(
                                                  itemHeight: 60,
                                                  elevation: 0,
                                                  value: liftInstallation,
                                                  isExpanded: true,
                                                  underline: Container(),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15),
                                                  ),
                                                  items: liftIntallationList
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      liftInstallation = val!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            DataCell(Text(
                                              'of',
                                              style: TextStyle(),
                                            )),
                                            DataCell(TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  liftInstalationTotalController,
                                            )),
                                            DataCell(Text(
                                              '5%',
                                              style: TextStyle(),
                                            )),
                                          ]),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  getBoldText(
                                      'Stage Analogue', Colors.black, 16),
                                  SizedBox(height: 10.0),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowHeight: 35,
                                      dataRowHeight: 35,
                                      headingTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  MyColors.primaryColor),
                                      border: TableBorder.all(
                                        color: Colors.grey,
                                      ),
                                      columns: const [
                                        // DataColumn(
                                        //   label: Text(''),
                                        // ),
                                        // DataColumn(label: Text('S No')),
                                        DataColumn(
                                            label: Text('Date of Visit')),
                                        DataColumn(label: Text('% Stage')),
                                      ],
                                      rows: list
                                          .map((e) => DataRow(
                                                cells: [
                                                  // DataCell(
                                                  //   Row(
                                                  //     children: [
                                                  //       GestureDetector(
                                                  //         child: Icon(
                                                  //           Icons.delete,
                                                  //           color: Colors.red,
                                                  //         ),
                                                  //         onTap: () {
                                                  //           setState(() {
                                                  //             list.remove(e);
                                                  //           });
                                                  //         },
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  DataCell(GestureDetector(
                                                    onTap: () async {
                                                      await _selectDate(context,
                                                          list.indexOf(e));
                                                    },
                                                    child: Container(
                                                      // color: Colors.red,
                                                      width: 100,
                                                      child: getNormalText(
                                                          tableDateControllerList[
                                                                  list.indexOf(
                                                                      e)]
                                                              .text,
                                                          Colors.black,
                                                          16),
                                                      // child: TextFormField(
                                                      //   readOnly: true,
                                                      //   controller:
                                                      //       tableDateControllerList[
                                                      //           list.indexOf(e)],
                                                      // ),
                                                    ),
                                                  )),
                                                  DataCell(TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        tableStageControllerList[
                                                            list.indexOf(e)],
                                                  )),
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
                                      getSmallButton('ADD FIELD', Colors.green,
                                          () {
                                        setState(() {
                                          tableDateControllerList
                                              .add(TextEditingController());
                                          tableStageControllerList
                                              .add(TextEditingController());
                                          list.add({
                                            'dateOfVisit':
                                                tableDateControllerList
                                                    .last.text,
                                            'stage': tableStageControllerList
                                                .last.text
                                          });
                                        });
                                      }, getTotalWidth(context) / 4)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  showCompuation
                                      ? TextFormField(
                                          controller: computeController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          maxLines: 5,
                                          minLines: 3,
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(),

                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Percentage of construction',
                            t: percentageOfConstructionController),
                        // CustomFormFiled(
                        //     title:
                        //         'For underconstruction projects workers and materials sighted',
                        //     t: forUnderConstructionController),
                        Container(
                          key: typeOfPropertyKey,
                          child: CustomDropdownButtonDynamicList(
                            value: typeOfProperty,
                            itemList: typeOfPropertyList,
                            onChanged: (newValue) {
                              setState(() {
                                typeOfProperty = newValue!;
                              });
                            },
                            hint: 'Type of Property',
                          ),
                        ),
                        Container(
                          key: propertyUsageKey,
                          child: CustomDropdownButtonDynamicList(
                            value: propertyUsage,
                            itemList: propertyUsageList,
                            onChanged: (newValue) {
                              setState(() {
                                propertyUsage = newValue!;
                              });
                            },
                            hint: 'Property usage',
                          ),
                        ),
                        Row(
                          children: [
                            getBoldText('Voilation Observed', Colors.black, 14),
                            getBoldText('*', Colors.red, 14)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: violationObservedKey,
                          child: MultiSelectDialogField(
                            initialValue: violationObserved ?? [],
                            items: voilationObservedMultiList,
                            title: Text("Voilation Observed"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey),
                            ),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            // buttonText: Text(
                            //   "Voilation Observed",
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            onConfirm: (results) {
                              violationObserved = results.cast<String>();
                              //_selectedAnimals = results;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title:
                                'In case of merged properties comment on kitchen, access door of each unit, can flat be bifurcated, hoe is unit merged on site',
                            t: inCaseOfMergedPropertiesController),
                        Row(
                          children: [
                            getBoldText('Comment on commercial usage',
                                Colors.black, 14),
                            getBoldText('*', Colors.red, 14)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: commentOnCommercialUsageKey,
                          child: MultiSelectDialogField(
                            initialValue: commentOnCommercialUsage ?? [],
                            items: commentOnCommercialUsageMultiList,
                            title: Text("Comment on commercial usage"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey),
                            ),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            // buttonText: Text(
                            //   "Comment on commercial usage",
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            onConfirm: (results) {
                              commentOnCommercialUsage = results.cast<String>();
                              //_selectedAnimals = results;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'Floor No in case of independent unit',
                            t: floorNumberInCaseOfIndependentController),
                        Container(
                          key: forPlotWihOrWithoutSuperstructKey,
                          child: CustomDropdownButtonDynamicList(
                            isRequired: false,
                            value: forPlotWihOrWithoutSuperstruct,
                            itemList: forPlotWihOrWithoutSuperstructList,
                            onChanged: (newValue) {
                              setState(() {
                                forPlotWihOrWithoutSuperstruct = newValue!;
                              });
                            },
                            hint:
                                'For plot with/ without superstructure- Comment on Demarcation by',
                          ),
                        ),
                        Container(
                          key: remarkOnViewFromPropertyKey,
                          child: CustomDropdownButtonDynamicList(
                            value: remarkOnViewFromProperty,
                            itemList: remarkOnViewFromPropertyList,
                            onChanged: (newValue) {
                              setState(() {
                                remarkOnViewFromProperty = newValue!;
                              });
                            },
                            hint: 'Remark on view from property',
                          ),
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'No of units per floor and position of unit',
                            t: noOfUnitPerFloorController),
                        Row(
                          children: [
                            getBoldText('Amenities Available in Socity',
                                Colors.black, 14),
                            getBoldText('*', Colors.red, 14),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: amenitiesAvailableKey,
                          child: MultiSelectDialogField(
                            initialValue: amenitiesAvailable ?? [],
                            items: amenitiesAvailableMultiList,
                            title: Text("Amenities Available in socity"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey),
                            ),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            // buttonText: Text(
                            //   "Amenities Available in socity",
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            onConfirm: (results) {
                              amenitiesAvailable = results.cast<String>();
                              //_selectedAnimals = results;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'Accomodation of unit',
                            t: accomodationOfUnitController),
                        Container(
                          key: noOfWingsKey,
                          child: CustomDropdownButtonDynamicList(
                            value: noOfWings,
                            itemList: noOfWingsList,
                            onChanged: (newValue) {
                              setState(() {
                                noOfWings = newValue!;
                              });
                            },
                            hint: 'No of wings in socity',
                          ),
                        ),
                        Row(
                          children: [
                            getBoldText('Construction type', Colors.black, 14),
                            getBoldText('*', Colors.red, 14)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: constructionTypeKey,
                          child: MultiSelectDialogField(
                            initialValue: constructionType ?? [],
                            items: constructionTypeMultiList,
                            title: Text("Construction type"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey),
                            ),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            // buttonText: Text(
                            //   "Construction type",
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            onConfirm: (results) {
                              constructionType = results.cast<String>();
                              //_selectedAnimals = results;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title:
                                'Any other details/remark related to property',
                            t: anyOtherDetailController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'No of storyes',
                            t: noOfStoreysController),
                        Container(
                          key: noOfLiftKey,
                          child: CustomDropdownButtonDynamicList(
                            value: noOfLift,
                            itemList: noOfLiftList,
                            onChanged: (newValue) {
                              setState(() {
                                noOfLift = newValue!;
                              });
                            },
                            hint: 'No of lifts',
                          ),
                        ),
                        Container(
                          key: exteriorKey,
                          child: CustomDropdownButtonDynamicList(
                            value: exterior,
                            itemList: exteriorList,
                            onChanged: (newValue) {
                              setState(() {
                                exterior = newValue!;
                              });
                            },
                            hint: 'Exterior',
                          ),
                        ),
                        Container(
                          key: interiorKey,
                          child: CustomDropdownButtonDynamicList(
                            value: interior,
                            itemList: interiorList,
                            onChanged: (newValue) {
                              setState(() {
                                interior = newValue!;
                              });
                            },
                            hint: 'Interior',
                          ),
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: kitchenPlatform,
                          itemList: kitchenPlatformList,
                          onChanged: (newValue) {
                            setState(() {
                              kitchenPlatform = newValue!;
                            });
                          },
                          hint: 'Kitchen Platform',
                        ),
                        Container(
                          key: fittingKey,
                          child: CustomDropdownButtonDynamicList(
                            value: fitting,
                            itemList: fittingList,
                            onChanged: (newValue) {
                              setState(() {
                                fitting = newValue!;
                              });
                            },
                            hint: 'Fitting',
                          ),
                        ),
                        Row(
                          children: [
                            getBoldText('Flooring', Colors.black, 14),
                            getBoldText('*', Colors.red, 14),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: flooringKey,
                          child: MultiSelectDialogField(
                            initialValue: flooring ?? [],
                            items: flooringMultiList,
                            title: Text("Flooring"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey),
                            ),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            // buttonText: Text(
                            //   "Flooring",
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            onConfirm: (results) {
                              flooring = results.cast<String>();
                              //_selectedAnimals = results;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          key: windowKey,
                          child: CustomDropdownButtonDynamicList(
                            value: window,
                            itemList: windowList,
                            onChanged: (newValue) {
                              setState(() {
                                window = newValue!;
                              });
                            },
                            hint: 'Window',
                          ),
                        ),
                        Container(
                          key: doorKey,
                          child: CustomDropdownButtonDynamicList(
                            value: door,
                            itemList: doorList,
                            onChanged: (newValue) {
                              setState(() {
                                door = newValue!;
                              });
                            },
                            hint: 'Door',
                          ),
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Floor to floor height of unit',
                            t: floorTofloorHeightController),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'Property age',
                            t: propertyAgeController),

                        Container(
                          key: maintainanceLevelKey,
                          child: CustomDropdownButtonDynamicList(
                            value: maintainanceLevel,
                            itemList: maintainanceLevelList,
                            onChanged: (newValue) {
                              setState(() {
                                maintainanceLevel = newValue!;
                              });
                            },
                            hint: 'Maintanance level of socity/Project',
                          ),
                        ),
                        CustomDropdownButton(
                          isRequired: false,
                          value: propertyAccVal,
                          itemList: propertyAccValList,
                          onChanged: (newValue) {
                            setState(() {
                              propertyAccVal = newValue!;
                            });
                          },
                          hint: 'Property_acc_value_HDFC',
                        ),
                        CustomDropdownButtonDynamicList(
                          isRequired: false,
                          value: isThePropertyIndependent,
                          itemList: isThePropertyIndependentList,
                          onChanged: (newValue) {
                            setState(() {
                              isThePropertyIndependent = newValue!;
                            });
                          },
                          hint:
                              'Is the property an independent unit and has independent access',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(),
                        SizedBox(
                          height: 15,
                        ),
                        getBoldText('VALUATION OBSERVATIONS', Colors.black, 16),
                        SizedBox(
                          height: 15,
                        ),
                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Carpet area as measured',
                            t: carpetAreaController),

                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            title: 'Rate per sq feet',
                            t: ratePerSqFtController),

                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'No of cars parked',
                            t: noOfCarParkedController),

                        CustomFormFiled(
                            setter: (val) {
                              setState(() {});
                            },
                            isRequired: false,
                            title: 'Rental per month',
                            t: rentalPerMonthController),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getBoldText('Engineer Remark', Colors.black, 14),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              minLines: 3,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              // textInputAction: TextInputAction.next,
                              controller: engineerRmeakrController,
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
                        //                 PhysicalInpectionOneForm(
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
                        //                 NDMAForm(
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
