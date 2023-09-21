import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:orgone_app/Api/api.dart';
import 'package:orgone_app/Screen/Forms/mmSheets.dart';
import 'package:orgone_app/Screen/Forms/physicalInspectionTwo.dart';
import 'package:orgone_app/Screen/Popups/boundries.dart';
import 'package:orgone_app/Screen/home_screen.dart';
import 'package:orgone_app/helper/colors.dart';
import 'package:orgone_app/helper/customDropdownDynamicList.dart';
import 'package:orgone_app/helper/customFormField.dart';
import 'package:orgone_app/helper/dropdown_button.dart';
import 'package:orgone_app/helper/threeDotMenu.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:orgone_app/Screen/home_page.dart';

import '../../helper/const.dart';

class PhysicalInpectionOneForm extends StatefulWidget {
  final bool isHistoryPage;
  final String vkid;
  const PhysicalInpectionOneForm(
      {super.key, required this.vkid, required this.isHistoryPage});

  @override
  State<PhysicalInpectionOneForm> createState() =>
      _PhysicalInpectionOneFormState();
}

class _PhysicalInpectionOneFormState extends State<PhysicalInpectionOneForm> {
  String? statusOfDevlopmentOfLocality;
  String? infraOfSurroundingArea;
  String? nighbourHoodType;
  String? localityConnectivityCBD;
  String? proximityToAmenities;
  String? accessibilityToPropertyFromMainRoad;
  String? commentOnOccupency;
  List<String>? waterConnectionSource;
  List<String>? parkingFacility;
  String? relationOfPersonMetAtSight;
  String? propertyOccupiedOrVaccant;
  String? relationShipOfoccupentWithCustomer;

  List<dynamic> statusOfDevlopmentOfLocalityList =
      constDropdownList!.developmentLocality;
  List<dynamic> infraOfSurroundingAreaList = constDropdownList!.infrastructure;
  List<dynamic> nighbourHoodTypeList = constDropdownList!.neighbourhood;
  List<dynamic> localityConnectivityCBDList = constDropdownList!.cbd;
  List<dynamic> proximityToAmenitiesList = constDropdownList!.proximities;
  List<dynamic> accessibilityToPropertyFromMainRoadList =
      constDropdownList!.accessibility;

  List<String> commentOnOccupencyList = [
    '15% to 30%',
    '30% to 45%',
    '45% to 60 %',
    '60 % to 75%',
    '75% to 90 %',
    'Less Than 90%',
    'Less than 70%',
    'Less than 85%',
    'More than 85%',
    'Desktop valuation hence not applicable',
    'Under construction',
    'Fully Occupied',
    'Vacant'
  ];
  List<String> waterConnectionSourceList = [
    'Bore Well Water',
    'Municipal Water',
    'Water Tanker Supply'
  ];
  List<String> parkingFacilityList = [
    'Open Parking available in the Premises',
    'Covered Car parking available in the Premises',
    'Parking Facility not available in the Premises'
  ];
  List<dynamic> relationOfPersonMetAtSightList =
      constDropdownList!.relationPersonMetAtSite;
  List<dynamic> propertyOccupiedOrVaccantList =
      constDropdownList!.propertyOccupiedVacant;
  List<String> relationShipOfoccupentWithCustomerList = [
    'Tenant',
    'Seller',
    'Self',
    'Vacant',
    'Under Construction',
    'External Visit Done hence cannot Comment',
    'Part self and part tenant',
    'NA',
  ];

  List<MultiSelectItem> waterConnectionSourceMultiList = [];
  List<MultiSelectItem> parkingFacalitiesMultiList = [];

  TextEditingController distanceFromLandmarkController =
      TextEditingController();
  TextEditingController distanceFromBankController = TextEditingController();
  TextEditingController nameOfNearestHospitalController =
      TextEditingController();
  TextEditingController conditionAndwidthOfAprrochRoadController =
      TextEditingController();
  TextEditingController nearestBusStopController = TextEditingController();
  TextEditingController nameOfPersonAtSiteController = TextEditingController();
  TextEditingController contactOfPersonAtSiteController =
      TextEditingController();
  TextEditingController nameOfSocityBoardController = TextEditingController();
  TextEditingController nameOfDoorAtUnitController = TextEditingController();
  TextEditingController nameOfOccupantController = TextEditingController();
  TextEditingController occupiedSinceController = TextEditingController();
  TextEditingController nameOfReportedOwnerController = TextEditingController();

  // Controller for boundries

  final TextEditingController eastBoundriesAsPerSiteController =
      TextEditingController();
  final TextEditingController eastBoundriesAsPerDeedController =
      TextEditingController();
  final TextEditingController eastDimensionAsPerSiteController =
      TextEditingController();
  final TextEditingController eastDimensionAsPerDeedController =
      TextEditingController();
  final TextEditingController eastMOSAsPerSiteController =
      TextEditingController();
  final TextEditingController eastMOSAsPerDeedController =
      TextEditingController();
  final TextEditingController westBoundriesAsPerSiteController =
      TextEditingController();
  final TextEditingController westBoundriesAsPerDeedController =
      TextEditingController();
  final TextEditingController westDimensionAsPerSiteController =
      TextEditingController();
  final TextEditingController westDimensionAsPerDeedController =
      TextEditingController();
  final TextEditingController westMOSAsPerSiteController =
      TextEditingController();
  final TextEditingController westMOSAsPerDeedController =
      TextEditingController();
  final TextEditingController northBoundriesAsPerSiteController =
      TextEditingController();
  final TextEditingController northBoundriesAsPerDeedController =
      TextEditingController();
  final TextEditingController northDimensionAsPerSiteController =
      TextEditingController();
  final TextEditingController northDimensionAsPerDeedController =
      TextEditingController();
  final TextEditingController northMOSAsPerSiteController =
      TextEditingController();
  final TextEditingController northMOSAsPerDeedController =
      TextEditingController();
  final TextEditingController southBoundriesAsPerSiteController =
      TextEditingController();
  final TextEditingController southBoundriesAsPerDeedController =
      TextEditingController();
  final TextEditingController southDimensionAsPerSiteController =
      TextEditingController();
  final TextEditingController southDimensionAsPerDeedController =
      TextEditingController();
  final TextEditingController southMOSAsPerSiteController =
      TextEditingController();
  final TextEditingController southMOSAsPerDeedController =
      TextEditingController();

  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();

  LocationData? _locationData;
  bool _isLocation = false;

  bool isStatusOfDevOfLoc = false;
  bool isInfraOfTheSorrounding = false;
  bool isDistanceFromRailway = false;
  bool isNegihbourhhodType = false;
  bool isLocalConnectivityFromCBD = false;
  bool isProximityToAmenities = false;
  bool isNameOfNearestHos = false;
  bool isAccessibilityToProp = false;
  bool isConditionandWidth = false;
  bool isNameOfNearestBus = false;
  bool isCommentOnOcc = false;
  bool isWaterConnSource = false;
  bool isParkingFac = false;
  bool isNameOfPErsonSite = false;
  bool isContactPersonMetAtSite = false;
  bool isRelationOfPersonAtSite = false;
  bool isNameOfSocityBoard = false;
  bool isNameOnDoorUnit = false;
  bool isPropOccOrVacc = false;
  bool isNameOfOcc = false;
  bool isOccSince = false;
  bool isNameOfReportedOwner = false;
  var statusOfDevlopmentOfLocalityKey = GlobalKey();
  var infraOfSurroundingAreaKey = GlobalKey();
  var nighbourHoodTypeKey = GlobalKey();
  var localityConnectivityCBDKey = GlobalKey();
  var proximityToAmenitiesKey = GlobalKey();
  var accessibilityToPropertyFromMainRoadKey = GlobalKey();
  var relationOfPersonMetAtSightKey = GlobalKey();
  var propertyOccupiedOrVaccantKey = GlobalKey();
  var commentOnOccupencyKey = GlobalKey();
  var waterConnectionSourceKey = GlobalKey();
  var parkingFacilityKey = GlobalKey();

  saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (statusOfDevlopmentOfLocality == null) {
        Scrollable.ensureVisible(
            statusOfDevlopmentOfLocalityKey.currentContext!);
        getSnackbar('Status of development of socity is required', context);
        return;
      }
      if (infraOfSurroundingArea == null) {
        Scrollable.ensureVisible(infraOfSurroundingAreaKey.currentContext!);
        getSnackbar(
            'Infrastructure of the surrounding area is required', context);
        return;
      }
      if (nighbourHoodType == null) {
        Scrollable.ensureVisible(nighbourHoodTypeKey.currentContext!);
        getSnackbar('Neighbourhood Type/Vicinity is required', context);
        return;
      }
      if (localityConnectivityCBD == null) {
        Scrollable.ensureVisible(localityConnectivityCBDKey.currentContext!);
        getSnackbar('Locality Connectivity from CBD is required', context);
        return;
      }
      if (proximityToAmenities == null) {
        Scrollable.ensureVisible(proximityToAmenitiesKey.currentContext!);
        getSnackbar('Proximity to Amenities is required', context);
        return;
      }
      if (accessibilityToPropertyFromMainRoad == null) {
        Scrollable.ensureVisible(
            accessibilityToPropertyFromMainRoadKey.currentContext!);
        getSnackbar(
            'Accessibility to Property from Main Road is required', context);
        return;
      }
      if (commentOnOccupency == null) {
        Scrollable.ensureVisible(commentOnOccupencyKey.currentContext!);
        getSnackbar('Comment on Occupancy is required', context);
        return;
      }
      if (waterConnectionSource == null) {
        Scrollable.ensureVisible(waterConnectionSourceKey.currentContext!);
        getSnackbar('Water Connection Source is required', context);
        return;
      }
      if (parkingFacility == null) {
        Scrollable.ensureVisible(parkingFacilityKey.currentContext!);
        getSnackbar(
            'Parking Facilities in the Project/Complex Premises is required',
            context);
        return;
      }
      if (relationOfPersonMetAtSight == null) {
        Scrollable.ensureVisible(relationOfPersonMetAtSightKey.currentContext!);
        getSnackbar('Relation of Person met at site is required', context);
        return;
      }
      if (propertyOccupiedOrVaccant == null) {
        Scrollable.ensureVisible(propertyOccupiedOrVaccantKey.currentContext!);
        getSnackbar('Property Occupied or Vacant is required', context);
        return;
      }

      setState(() {
        isLoading = true;
      });

      String wcs = '';
      String pfl = '';

      if (waterConnectionSource != null) {
        waterConnectionSource!.forEach((element) {
          wcs = wcs + element + ',';
        });
      }

      if (parkingFacility != null) {
        parkingFacility!.forEach((element) {
          pfl = pfl + element + ',';
        });
      }

      Map<String, dynamic> data = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'property_area_locality': statusOfDevlopmentOfLocality ?? '',
        'neighbourhood_type': nighbourHoodType ?? '',
        'connectivity': localityConnectivityCBD ?? '',
        'accessibility': accessibilityToPropertyFromMainRoad ?? '',
        'infrastructure_surrounding_area': infraOfSurroundingArea ?? '',
        'walking_distance': distanceFromLandmarkController.text.toString(),
        'nearest_hospital': nameOfNearestHospitalController.text.toString(),
        'nearest_bus_stop': nearestBusStopController.text.toString(),
        'condition_width_approach_road':
            conditionAndwidthOfAprrochRoadController.text.toString(),
        'proximity_amenities': proximityToAmenities ?? '',
        'distance_from_bank': distanceFromBankController.text.toString(),
        'person_metatsite': nameOfPersonAtSiteController.text.toString(),
        'relation_person_met_customer': relationOfPersonMetAtSight ?? '',
        'name_society_board': nameOfSocityBoardController.text.toString(),
        'name_door_unit': nameOfDoorAtUnitController.text.toString(),
        'property_occupied_vacant': propertyOccupiedOrVaccant ?? '',
        'contact_person_site': contactOfPersonAtSiteController.text.toString(),
        'name_reported_owner_site':
            nameOfReportedOwnerController.text.toString(),
        'relation_person_occupant_customer':
            relationShipOfoccupentWithCustomer ?? '',
        'occupied_since': occupiedSinceController.text.toString(),
        'name_occupant': nameOfOccupantController.text.toString(),
        'created_date': DateTime.now().toString(),
        'zoneas_per_city': '',
        'marketability': '',
        'location_property': '',
        'boundaries_matching': '',
        'comment_occ': commentOnOccupency ?? '',
        'water_conn': wcs,
        'parking_fac': pfl,
      };

      print(data);

      Map<String, dynamic> eastData = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'direction': 'east',
        'boundaries_as_per_site': eastBoundriesAsPerSiteController.text,
        'boundaries_as_per_deed': eastBoundriesAsPerDeedController.text,
        'dimension_as_per_site': eastDimensionAsPerSiteController.text,
        'dimension_as_per_deed': eastDimensionAsPerDeedController.text,
        'mos_as_per_site': eastMOSAsPerSiteController.text,
        'mos_as_per_deed': eastMOSAsPerDeedController.text,
      };
      Map<String, dynamic> westData = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'direction': 'west',
        'boundaries_as_per_site': westBoundriesAsPerSiteController.text,
        'boundaries_as_per_deed': westBoundriesAsPerDeedController.text,
        'dimension_as_per_site': westDimensionAsPerSiteController.text,
        'dimension_as_per_deed': westDimensionAsPerDeedController.text,
        'mos_as_per_site': westMOSAsPerSiteController.text,
        'mos_as_per_deed': westMOSAsPerDeedController.text,
      };
      Map<String, dynamic> northData = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'direction': 'north',
        'boundaries_as_per_site': northBoundriesAsPerSiteController.text,
        'boundaries_as_per_deed': northBoundriesAsPerDeedController.text,
        'dimension_as_per_site': northDimensionAsPerSiteController.text,
        'dimension_as_per_deed': northDimensionAsPerDeedController.text,
        'mos_as_per_site': northMOSAsPerSiteController.text,
        'mos_as_per_deed': northMOSAsPerDeedController.text,
      };
      Map<String, dynamic> southData = {
        'vkid': widget.vkid,
        'created_by': constUserModel!.userCode,
        'direction': 'south',
        'boundaries_as_per_site': southBoundriesAsPerSiteController.text,
        'boundaries_as_per_deed': southBoundriesAsPerDeedController.text,
        'dimension_as_per_site': southDimensionAsPerSiteController.text,
        'dimension_as_per_deed': southDimensionAsPerDeedController.text,
        'mos_as_per_site': southMOSAsPerSiteController.text,
        'mos_as_per_deed': southMOSAsPerDeedController.text,
      };

      var res = await getPostCall(physicalInspectionOneUrl, data);

      var eastRes = await getPostCall(boundriesUrl, eastData);
      var westRes = await getPostCall(boundriesUrl, westData);
      var northRes = await getPostCall(boundriesUrl, northData);
      var southRes = await getPostCall(boundriesUrl, southData);

      setState(() {
        isLoading = false;
      });
      print(res.body);
      var getData = json.decode(res.body);

      var getEastRes = json.decode(eastRes.body);
      var getWestRes = json.decode(westRes.body);
      var getNorthRes = json.decode(northRes.body);
      var getSouthRes = json.decode(southRes.body);
      getSnackbar(getData['message'], context);
      if (getData['status'] == 'success') {
        pushNavigate(context,
            PhysicalInpectionTwoForm(vkid: widget.vkid, isHistoryPage: false));
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
    Map<String, dynamic> data = getData['physicalInspection1'];
    print(data);
    List<dynamic> directionData = [];
    directionData.addAll(getData['boundariesDimension']);
    try {
      statusOfDevlopmentOfLocality = statusOfDevlopmentOfLocalityList
          .firstWhere((element) {
            return element.name.toString() ==
                data['PROPERTY_AREA_LOCALITY'].toString();
          })
          .name
          .toString();
      statusOfDevlopmentOfLocality == null ? null : isStatusOfDevOfLoc = true;
    } catch (e) {
      print(e);
      statusOfDevlopmentOfLocality = null;
    }
    try {
      infraOfSurroundingArea = infraOfSurroundingAreaList
          .firstWhere((element) {
            return element.name.toString() ==
                data['INFRASTRUCTURE_SURROUNDING_AREA'].toString();
          })
          .name
          .toString();
      infraOfSurroundingArea == null ? null : isInfraOfTheSorrounding = true;
    } catch (e) {
      infraOfSurroundingArea = null;
    }

    try {
      distanceFromLandmarkController.text = data['WALKING_DISTANCE'].toString();
      distanceFromLandmarkController.text.isEmpty
          ? null
          : isDistanceFromRailway = true;
    } catch (e) {
      distanceFromLandmarkController.text = '';
    }
    try {
      nighbourHoodType = nighbourHoodTypeList
          .firstWhere((element) {
            return element.name.toString() ==
                data['NEIGHBOURHOOD_TYPE'].toString();
          })
          .name
          .toString();
      nighbourHoodType == null ? null : isNegihbourhhodType = true;
    } catch (e) {
      nighbourHoodType = null;
    }
    try {
      distanceFromBankController.text = data['DISTANCE_FROM_BANK'].toString();
    } catch (e) {
      distanceFromBankController.text = '';
    }
    try {
      localityConnectivityCBD = localityConnectivityCBDList
          .firstWhere((element) {
            return element.name.toString() == data['CONNECTIVITY'].toString();
          })
          .name
          .toString();
      localityConnectivityCBD == null
          ? null
          : isLocalConnectivityFromCBD = true;
    } catch (e) {
      localityConnectivityCBD = null;
    }
    try {
      proximityToAmenities = proximityToAmenitiesList
          .firstWhere((element) {
            return element.name.toString() ==
                data['PROXIMITY_AMENITIES'].toString();
          })
          .name
          .toString();
      proximityToAmenities == null ? null : isProximityToAmenities = true;
    } catch (e) {
      proximityToAmenities = null;
    }
    try {
      nameOfNearestHospitalController.text =
          data['NEAREST_HOSPITAL'].toString();
      nameOfNearestHospitalController.text.isEmpty
          ? null
          : isNameOfNearestHos = true;
    } catch (e) {
      nameOfNearestHospitalController.text = '';
    }
    try {
      accessibilityToPropertyFromMainRoad =
          accessibilityToPropertyFromMainRoadList
              .firstWhere((element) {
                return element.name.toString() ==
                    data['ACCESSIBILITY'].toString();
              })
              .name
              .toString();
      accessibilityToPropertyFromMainRoad == null
          ? null
          : isAccessibilityToProp = true;
    } catch (e) {
      accessibilityToPropertyFromMainRoad = null;
    }
    try {
      conditionAndwidthOfAprrochRoadController.text =
          data['CONDITION_WIDTH_APPROACH_ROAD'].toString();
      conditionAndwidthOfAprrochRoadController.text.isEmpty
          ? null
          : isConditionandWidth = true;
    } catch (e) {
      conditionAndwidthOfAprrochRoadController.text = '';
    }
    try {
      nearestBusStopController.text = data['NEAREST_BUS_STOP'];
      nearestBusStopController.text.isEmpty ? null : isNameOfNearestBus = true;
    } catch (e) {
      nearestBusStopController.text = '';
    }
    try {
      commentOnOccupency = commentOnOccupencyList.firstWhere((element) {
        return element == data['COMMENT_OCCUPANCY'];
      }).toString();
      commentOnOccupency == null ? null : isCommentOnOcc = true;
    } catch (e) {
      commentOnOccupency = null;
    }
    try {
      waterConnectionSource = data['WATER_CONNECTION'].split(',');
      // waterConnectionSource = waterConnectionSourceList.firstWhere((element) {
      //   return element == data['WATER_CONNECTION'];
      // }).toString();
      waterConnectionSource == null ? null : isWaterConnSource = true;
    } catch (e) {
      print(e);
      waterConnectionSource = null;
    }
    try {
      parkingFacility = data['PARKING_FACILITIES'].split(',');
      // parkingFacility = parkingFacilityList.firstWhere((element) {
      //   return element == data['PARKING_FACILITIES'];
      // }).toString();
      parkingFacility == null ? null : isParkingFac = true;
    } catch (e) {
      parkingFacility = null;
    }
    try {
      nameOfPersonAtSiteController.text = data['PERSON_METATSITE'].toString();
      nameOfPersonAtSiteController.text.isEmpty
          ? null
          : isNameOfPErsonSite = true;
    } catch (e) {
      nameOfPersonAtSiteController.text = '';
    }
    try {
      contactOfPersonAtSiteController.text =
          data['CONTACT_PERSON_SITE'].toString();
      contactOfPersonAtSiteController.text.isEmpty
          ? null
          : isContactPersonMetAtSite = true;
    } catch (e) {
      contactOfPersonAtSiteController.text = '';
    }
    try {
      relationOfPersonMetAtSight = relationOfPersonMetAtSightList
          .firstWhere((element) {
            return element.name.toString() ==
                data['RELATION_PERSON_MET_CUSTOMER'].toString();
          })
          .name
          .toString();
      relationOfPersonMetAtSight == null
          ? null
          : isRelationOfPersonAtSite = true;
    } catch (e) {
      relationOfPersonMetAtSight = null;
    }
    try {
      nameOfSocityBoardController.text = data['NAME_SOCIETY_BOARD'].toString();
      nameOfSocityBoardController.text.isEmpty
          ? null
          : isNameOfSocityBoard = true;
    } catch (e) {
      nameOfSocityBoardController.text = '';
    }
    try {
      nameOfDoorAtUnitController.text = data['NAME_DOOR_UNIT'].toString();
      nameOfDoorAtUnitController.text.isEmpty ? null : isNameOnDoorUnit = true;
    } catch (e) {
      nameOfDoorAtUnitController.text = '';
    }

    try {
      propertyOccupiedOrVaccant = propertyOccupiedOrVaccantList
          .firstWhere((element) {
            return element.name.toString() ==
                data['PROPERTY_OCCUPIED_VACANT'].toString();
          })
          .name
          .toString();
      propertyOccupiedOrVaccant == null ? null : isPropOccOrVacc = true;
    } catch (e) {
      propertyOccupiedOrVaccant = null;
    }

    try {
      nameOfOccupantController.text = data['NAME_OCCUPANT'];
      nameOfOccupantController.text.isEmpty ? null : isNameOfOcc = true;
    } catch (e) {
      nameOfOccupantController.text = '';
    }

    try {
      relationShipOfoccupentWithCustomer =
          relationShipOfoccupentWithCustomerList.firstWhere((element) {
        return element == data['RELATION_PERSON_OCCUPANT_CUSTOMER'];
      }).toString();
    } catch (e) {
      relationShipOfoccupentWithCustomer = null;
    }

    try {
      occupiedSinceController.text = data['OCCUPIED_SINCE'].toString();
      occupiedSinceController.text.isEmpty ? null : isOccSince = true;
    } catch (e) {
      occupiedSinceController.text = '';
    }
    try {
      nameOfReportedOwnerController.text =
          data['NAME_REPORTED_OWNER_SITE'].toString();
      nameOfReportedOwnerController.text.isEmpty
          ? null
          : isNameOfReportedOwner = true;
    } catch (e) {
      nameOfReportedOwnerController.text = '';
    }

    setState(() {});
    if (directionData.isNotEmpty) {
      for (var element in directionData) {
        if (element['DIRECTION'].toString().toLowerCase() == 'east') {
          eastBoundriesAsPerSiteController.text =
              element['BOUNDARIES_AS_PER_SITE'].toString();
          eastBoundriesAsPerDeedController.text =
              element['BOUNDARIES_AS_PER_DEED'].toString();
          eastDimensionAsPerSiteController.text =
              element['DIMENSION_AS_PER_SITE'].toString();
          eastDimensionAsPerDeedController.text =
              element['DIMENSION_AS_PER_DEED'].toString();
          eastMOSAsPerSiteController.text =
              element['MOS_AS_PER_SITE'].toString();
          eastMOSAsPerDeedController.text =
              element['MOS_AS_PER_DEED'].toString();
        } else if (element['DIRECTION'].toString().toLowerCase() == 'west') {
          westBoundriesAsPerSiteController.text =
              element['BOUNDARIES_AS_PER_SITE'].toString();
          westBoundriesAsPerDeedController.text =
              element['BOUNDARIES_AS_PER_DEED'].toString();
          westDimensionAsPerSiteController.text =
              element['DIMENSION_AS_PER_SITE'].toString();
          westDimensionAsPerDeedController.text =
              element['DIMENSION_AS_PER_DEED'].toString();
          westMOSAsPerSiteController.text =
              element['MOS_AS_PER_SITE'].toString();
          westMOSAsPerDeedController.text =
              element['MOS_AS_PER_DEED'].toString();
        } else if (element['DIRECTION'].toString().toLowerCase() == 'north') {
          northBoundriesAsPerSiteController.text =
              element['BOUNDARIES_AS_PER_SITE'].toString();
          northBoundriesAsPerDeedController.text =
              element['BOUNDARIES_AS_PER_DEED'].toString();
          northDimensionAsPerSiteController.text =
              element['DIMENSION_AS_PER_SITE'].toString();
          northDimensionAsPerDeedController.text =
              element['DIMENSION_AS_PER_DEED'].toString();
          northMOSAsPerSiteController.text =
              element['MOS_AS_PER_SITE'].toString();
          northMOSAsPerDeedController.text =
              element['MOS_AS_PER_DEED'].toString();
        } else if (element['DIRECTION'].toString().toLowerCase() == 'south') {
          southBoundriesAsPerSiteController.text =
              element['BOUNDARIES_AS_PER_SITE'].toString();
          southBoundriesAsPerDeedController.text =
              element['BOUNDARIES_AS_PER_DEED'].toString();
          southDimensionAsPerSiteController.text =
              element['DIMENSION_AS_PER_SITE'].toString();
          southDimensionAsPerDeedController.text =
              element['DIMENSION_AS_PER_DEED'].toString();
          southMOSAsPerSiteController.text =
              element['MOS_AS_PER_SITE'].toString();
          southMOSAsPerDeedController.text =
              element['MOS_AS_PER_DEED'].toString();
        }
      }
    }
  }

  @override
  void initState() {
    waterConnectionSourceMultiList = waterConnectionSourceList
        .map((val) => MultiSelectItem<String>(val, val))
        .toList();
    parkingFacalitiesMultiList = parkingFacilityList
        .map((val) => MultiSelectItem<String>(val, val))
        .toList();
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getBoldText('Physical Inspection One', Colors.white, 16),
        actions: [
          IconButton(
              onPressed: () {
                pushAndRemoveUntilNavigate(context, HomeScreen());
              },
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              )),
          ThreeDotMenu(
            isHistoryPage: widget.isHistoryPage,
            vkid: widget.vkid,
          ),
        ],
      ),
      bottomSheet: widget.isHistoryPage
          ? Container()
          : Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // (!isStatusOfDevOfLoc ||
                  //         !isInfraOfTheSorrounding ||
                  //         !isDistanceFromRailway ||
                  //         !isNegihbourhhodType ||
                  //         !isLocalConnectivityFromCBD ||
                  //         !isProximityToAmenities ||
                  //         !isNameOfNearestHos ||
                  //         !isAccessibilityToProp ||
                  //         !isConditionandWidth ||
                  //         !isNameOfNearestBus ||
                  //         !isCommentOnOcc ||
                  //         !isWaterConnSource ||
                  //         !isParkingFac ||
                  //         !isNameOfPErsonSite ||
                  //         !isContactPersonMetAtSite ||
                  //         !isRelationOfPersonAtSite ||
                  //         !isNameOfSocityBoard ||
                  //         !isNameOnDoorUnit ||
                  //         !isPropOccOrVacc ||
                  //         !isNameOfOcc ||
                  //         !isOccSince ||
                  //         !isNameOfReportedOwner)
                  //     ? getButton('Save', Colors.grey, Colors.grey,
                  //         () {}, getTotalWidth(context) / 2)
                  // :
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
                    MMSheetsForm(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getBoldText('DETAIL OF PROPERTY LOCATION',
                                Colors.black, 16),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              key: statusOfDevlopmentOfLocalityKey,
                              child: CustomDropdownButtonDynamicList(
                                value: statusOfDevlopmentOfLocality,
                                itemList: statusOfDevlopmentOfLocalityList,
                                onChanged: (newValue) {
                                  setState(() {
                                    statusOfDevlopmentOfLocality = newValue!;
                                    isStatusOfDevOfLoc = true;
                                  });
                                },
                                hint: 'Status of development of locality ',
                              ),
                            ),
                            Container(
                              key: infraOfSurroundingAreaKey,
                              child: CustomDropdownButtonDynamicList(
                                value: infraOfSurroundingArea,
                                itemList: infraOfSurroundingAreaList,
                                onChanged: (newValue) {
                                  setState(() {
                                    infraOfSurroundingArea = newValue!;
                                    isInfraOfTheSorrounding = true;
                                  });
                                },
                                hint: 'Infrastructure of the sorrounding area ',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isDistanceFromRailway = false
                                        : isDistanceFromRailway = true;
                                  });
                                },
                                title:
                                    'Distance from Landmark/ Railway Station',
                                t: distanceFromLandmarkController),
                            Container(
                              key: nighbourHoodTypeKey,
                              child: CustomDropdownButtonDynamicList(
                                value: nighbourHoodType,
                                itemList: nighbourHoodTypeList,
                                onChanged: (newValue) {
                                  setState(() {
                                    nighbourHoodType = newValue!;
                                    isNegihbourhhodType = true;
                                  });
                                },
                                hint: 'Neighbourhood Type',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {});
                                },
                                isRequired: false,
                                title: 'Distance from Bank/FI Branch',
                                t: distanceFromBankController),
                            Container(
                              key: localityConnectivityCBDKey,
                              child: CustomDropdownButtonDynamicList(
                                value: localityConnectivityCBD,
                                itemList: localityConnectivityCBDList,
                                onChanged: (newValue) {
                                  setState(() {
                                    localityConnectivityCBD = newValue!;
                                    isLocalConnectivityFromCBD = true;
                                  });
                                },
                                hint: 'Locality Connectivity from CBD',
                              ),
                            ),
                            Container(
                              key: proximityToAmenitiesKey,
                              child: CustomDropdownButtonDynamicList(
                                value: proximityToAmenities,
                                itemList: proximityToAmenitiesList,
                                onChanged: (newValue) {
                                  setState(() {
                                    proximityToAmenities = newValue!;
                                    isProximityToAmenities = true;
                                  });
                                },
                                hint:
                                    'Proximity to Amenities eg School, Mall etc',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfNearestHos = false
                                        : isNameOfNearestHos = true;
                                  });
                                },
                                title: 'Name of nearest hospital',
                                t: nameOfNearestHospitalController),
                            Container(
                              key: accessibilityToPropertyFromMainRoadKey,
                              child: CustomDropdownButtonDynamicList(
                                value: accessibilityToPropertyFromMainRoad,
                                itemList:
                                    accessibilityToPropertyFromMainRoadList,
                                onChanged: (newValue) {
                                  setState(() {
                                    accessibilityToPropertyFromMainRoad =
                                        newValue!;
                                    isAccessibilityToProp = true;
                                  });
                                },
                                hint:
                                    'Accessibility to property from main road',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isConditionandWidth = false
                                        : isConditionandWidth = true;
                                  });
                                },
                                title: 'Condition and width of approch road',
                                t: conditionAndwidthOfAprrochRoadController),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfNearestBus = false
                                        : isNameOfNearestBus = true;
                                  });
                                },
                                title: 'Name of nearest bus stop',
                                t: nearestBusStopController),
                            Container(
                              key: commentOnOccupencyKey,
                              child: CustomDropdownButton(
                                value: commentOnOccupency,
                                itemList: commentOnOccupencyList,
                                onChanged: (newValue) {
                                  setState(() {
                                    commentOnOccupency = newValue!;
                                    isCommentOnOcc = true;
                                  });
                                },
                                hint: 'Comment on occupancy',
                              ),
                            ),
                            // CustomDropdownButton(
                            //   value: waterConnectionSource,
                            //   itemList: waterConnectionSourceList,
                            //   onChanged: (newValue) {
                            //     setState(() {
                            //       waterConnectionSource = newValue!;
                            //     });
                            //   },
                            //   hint: 'Water condition source',
                            // ),
                            getBoldText(
                                'Water Connection source*', Colors.black, 14),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              key: waterConnectionSourceKey,
                              child: MultiSelectDialogField(
                                initialValue: waterConnectionSource ?? [],
                                items: waterConnectionSourceMultiList,
                                title: Text("Water Connection Source"),
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
                                //   "Water Connection source",
                                //   style: TextStyle(
                                //     color: Colors.grey,
                                //     fontSize: 16,
                                //   ),
                                // ),
                                onConfirm: (results) {
                                  waterConnectionSource =
                                      results.cast<String>();
                                  isWaterConnSource = true;
                                  //_selectedAnimals = results;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            getBoldText(
                                'Parking Facalities in the Project/Complex Premises*',
                                Colors.black,
                                14),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              key: parkingFacilityKey,
                              child: MultiSelectDialogField(
                                initialValue: parkingFacility ?? [],
                                items: parkingFacalitiesMultiList,
                                title: Text("Parking Facalities"),
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
                                //   "Parking Facalities",
                                //   style: TextStyle(
                                //     color: Colors.grey,
                                //     fontSize: 16,
                                //   ),
                                // ),
                                onConfirm: (results) {
                                  parkingFacility = results.cast<String>();
                                  isParkingFac = true;
                                  //_selectedAnimals = results;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // CustomDropdownButton(
                            //   value: parkingFacility,
                            //   itemList: parkingFacilityList,
                            //   onChanged: (newValue) {
                            //     setState(() {
                            //       parkingFacility = newValue!;
                            //     });
                            //   },
                            //   hint:
                            //       'Parking Facalities in the Project/Complex Premises',
                            // ),
                            const Divider(),
                            const SizedBox(
                              height: 20,
                            ),

                            getBoldText(
                                'BUILDING/PLOT BOUNDRIES AND DIMENSIONS',
                                Colors.black,
                                16),
                            const SizedBox(
                              height: 20,
                            ),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                  headingRowHeight: 35,
                                  dataRowHeight: 35,
                                  headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => MyColors.primaryColor),
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                  ),
                                  columns: [
                                    const DataColumn(label: Text('Direction')),
                                    const DataColumn(
                                        label: Text('Boundries(As per site)')),
                                    const DataColumn(
                                        label: Text('Boundries(As per deed)')),
                                    const DataColumn(
                                        label: Text('Dimension(As per site)')),
                                    const DataColumn(
                                        label: Text('Dimension(As per deed)')),
                                    const DataColumn(
                                        label: Text('MOS(As per site)')),
                                    const DataColumn(
                                        label: Text('MOS(As per deed)')),
                                  ],
                                  rows: [
                                    DataRow(cells: [
                                      const DataCell(Text(
                                        'East',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(Text(
                                          eastBoundriesAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          eastBoundriesAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          eastDimensionAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          eastDimensionAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          eastMOSAsPerSiteController.text)),
                                      DataCell(Text(
                                          eastMOSAsPerDeedController.text)),
                                    ]),
                                    DataRow(cells: [
                                      const DataCell(Text(
                                        'West',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(Text(
                                          westBoundriesAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          westBoundriesAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          westDimensionAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          westDimensionAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          westMOSAsPerSiteController.text)),
                                      DataCell(Text(
                                          westMOSAsPerDeedController.text)),
                                    ]),
                                    DataRow(cells: [
                                      const DataCell(Text(
                                        'North',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(Text(
                                          northBoundriesAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          northBoundriesAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          northDimensionAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          northDimensionAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          northMOSAsPerSiteController.text)),
                                      DataCell(Text(
                                          northMOSAsPerDeedController.text)),
                                    ]),
                                    DataRow(cells: [
                                      const DataCell(
                                        Text(
                                          'South',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataCell(Text(
                                          southBoundriesAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          southBoundriesAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          southDimensionAsPerSiteController
                                              .text)),
                                      DataCell(Text(
                                          southDimensionAsPerDeedController
                                              .text)),
                                      DataCell(Text(
                                          southMOSAsPerSiteController.text)),
                                      DataCell(Text(
                                          southMOSAsPerDeedController.text)),
                                    ]),
                                  ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                getSmallButton('ADD/EDIT', Colors.green, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddBoundries(
                                          eastBoundriesAsPerSiteController:
                                              eastBoundriesAsPerSiteController,
                                          eastBoundriesAsPerDeedController:
                                              eastBoundriesAsPerDeedController,
                                          eastDimensionAsPerSiteController:
                                              eastDimensionAsPerSiteController,
                                          eastDimensionAsPerDeedController:
                                              eastDimensionAsPerDeedController,
                                          eastMOSAsPerSiteController:
                                              eastMOSAsPerSiteController,
                                          eastMOSAsPerDeedController:
                                              eastMOSAsPerDeedController,
                                          westBoundriesAsPerSiteController:
                                              westBoundriesAsPerSiteController,
                                          westBoundriesAsPerDeedController:
                                              westBoundriesAsPerDeedController,
                                          westDimensionAsPerSiteController:
                                              westDimensionAsPerSiteController,
                                          westDimensionAsPerDeedController:
                                              westDimensionAsPerDeedController,
                                          westMOSAsPerSiteController:
                                              westMOSAsPerSiteController,
                                          westMOSAsPerDeedController:
                                              westMOSAsPerDeedController,
                                          northBoundriesAsPerSiteController:
                                              northBoundriesAsPerSiteController,
                                          northBoundriesAsPerDeedController:
                                              northBoundriesAsPerDeedController,
                                          northDimensionAsPerSiteController:
                                              northDimensionAsPerSiteController,
                                          northDimensionAsPerDeedController:
                                              northDimensionAsPerDeedController,
                                          northMOSAsPerSiteController:
                                              northMOSAsPerSiteController,
                                          northMOSAsPerDeedController:
                                              northMOSAsPerDeedController,
                                          southBoundriesAsPerSiteController:
                                              southBoundriesAsPerSiteController,
                                          southBoundriesAsPerDeedController:
                                              southBoundriesAsPerDeedController,
                                          southDimensionAsPerSiteController:
                                              southDimensionAsPerSiteController,
                                          southDimensionAsPerDeedController:
                                              southDimensionAsPerDeedController,
                                          southMOSAsPerSiteController:
                                              southMOSAsPerSiteController,
                                          southMOSAsPerDeedController:
                                              southMOSAsPerDeedController);
                                    },
                                  );
                                }, 100),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // NestedColumnTable(),
                            const Divider(),
                            const SizedBox(
                              height: 20,
                            ),

                            getBoldText(
                                'DETAIL OF CUSTOMER MEETING', Colors.black, 16),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfPErsonSite = false
                                        : isNameOfPErsonSite = true;
                                  });
                                },
                                title: 'Name of person met at site',
                                t: nameOfPersonAtSiteController),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isContactPersonMetAtSite = false
                                        : isContactPersonMetAtSite = true;
                                  });
                                },
                                title: 'Contact of person met at site',
                                t: contactOfPersonAtSiteController),
                            Container(
                              key: relationOfPersonMetAtSightKey,
                              child: CustomDropdownButtonDynamicList(
                                value: relationOfPersonMetAtSight,
                                itemList: relationOfPersonMetAtSightList,
                                onChanged: (newValue) {
                                  setState(() {
                                    relationOfPersonMetAtSight = newValue!;
                                    isRelationOfPersonAtSite = true;
                                  });
                                },
                                hint: 'Relation to person met at site',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfSocityBoard = false
                                        : isNameOfSocityBoard = true;
                                  });
                                },
                                title: 'Name of socity board',
                                t: nameOfSocityBoardController),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOnDoorUnit = false
                                        : isNameOnDoorUnit = true;
                                  });
                                },
                                title: 'Name on door of the unit',
                                t: nameOfDoorAtUnitController),
                            Container(
                              key: propertyOccupiedOrVaccantKey,
                              child: CustomDropdownButtonDynamicList(
                                value: propertyOccupiedOrVaccant,
                                itemList: propertyOccupiedOrVaccantList,
                                onChanged: (newValue) {
                                  setState(() {
                                    propertyOccupiedOrVaccant = newValue!;
                                    isPropOccOrVacc = true;
                                  });
                                },
                                hint: 'Property occupied/vaccant',
                              ),
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfOcc = false
                                        : isNameOfOcc = true;
                                  });
                                },
                                title: 'Name of occupant',
                                t: nameOfOccupantController),
                            CustomDropdownButton(
                              isRequired: false,
                              value: relationShipOfoccupentWithCustomer,
                              itemList: relationShipOfoccupentWithCustomerList,
                              onChanged: (newValue) {
                                setState(() {
                                  relationShipOfoccupentWithCustomer =
                                      newValue!;
                                });
                              },
                              hint: 'Relationship of occupant with customer',
                            ),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isOccSince = false
                                        : isOccSince = true;
                                  });
                                },
                                title: 'Occupied Since',
                                t: occupiedSinceController),
                            CustomFormFiled(
                                setter: (val) {
                                  setState(() {
                                    val.isEmpty
                                        ? isNameOfReportedOwner = false
                                        : isNameOfReportedOwner = true;
                                  });
                                },
                                title:
                                    'Name of reported owner as per site information',
                                t: nameOfReportedOwnerController),

                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
