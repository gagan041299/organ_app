class LiveCasesModel {
  LiveCasesModel({
    required this.vkid,
    required this.institutionType,
    required this.name,
    required this.instDesc,
    required this.requestDate,
    required this.scheduledDate,
    required this.fileRefno,
    required this.engDate,
    required this.submitStatusDate,
    required this.engTime,
    required this.callStatus,
    required this.borrowerName,
    required this.contactPerson,
    required this.mobileNo1,
    required this.mobileNo2,
    required this.mobileNo3,
    required this.landlineNo1,
    required this.landlineNo2,
    required this.loanType,
    required this.legalDocument,
    required this.visitAllocated,
    required this.visitAllocatedName,
    required this.propertyAddress,
    required this.caseStatus,
    required this.flatNo,
    required this.floorWing,
    required this.societyBuilding,
    required this.plotNo,
    required this.sectorColony,
    required this.roadArea,
    required this.location,
    required this.locationName,
    required this.ctsSurveyVillage,
    required this.district,
    required this.splInstruction,
    required this.pinCode,
    required this.createdDate,
    required this.createdBy,
    required this.modifiedDate,
    required this.modifiedBy,
    required this.priorityFlag,
    required this.appSubmitStatus,
    required this.orderCondition,
    required this.casNo,
    required this.copyFlag,
    required this.oldCase,
  });

  final dynamic vkid;
  final dynamic institutionType;
  final dynamic name;
  final dynamic instDesc;
  final dynamic requestDate;
  final dynamic scheduledDate;
  final dynamic fileRefno;
  final dynamic engDate;
  final dynamic submitStatusDate;
  final dynamic engTime;
  final dynamic callStatus;
  final dynamic borrowerName;
  final dynamic contactPerson;
  final dynamic mobileNo1;
  final dynamic mobileNo2;
  final dynamic mobileNo3;
  final dynamic landlineNo1;
  final dynamic landlineNo2;
  final dynamic loanType;
  final dynamic legalDocument;
  final dynamic visitAllocated;
  final dynamic visitAllocatedName;
  final dynamic propertyAddress;
  final dynamic caseStatus;
  final dynamic flatNo;
  final dynamic floorWing;
  final dynamic societyBuilding;
  final dynamic plotNo;
  final dynamic sectorColony;
  final dynamic roadArea;
  final dynamic location;
  final dynamic locationName;
  final dynamic ctsSurveyVillage;
  final dynamic district;
  final dynamic splInstruction;
  final dynamic pinCode;
  final DateTime? createdDate;
  final dynamic createdBy;
  final dynamic modifiedDate;
  final dynamic modifiedBy;
  final dynamic priorityFlag;
  final dynamic appSubmitStatus;
  final dynamic orderCondition;
  final dynamic casNo;
  final dynamic copyFlag;
  final dynamic oldCase;

  factory LiveCasesModel.fromJson(Map<String, dynamic> json) {
    return LiveCasesModel(
      vkid: json["VKID"].toString(),
      institutionType: json["INSTITUTION_TYPE"],
      name: json["NAME"],
      instDesc: json["INST_DESC"],
      requestDate: json["REQUEST_DATE"],
      scheduledDate: json["SCHEDULED_DATE"],
      fileRefno: json["FILE_REFNO"],
      engDate: json["ENG_DATE"],
      submitStatusDate: json["SUBMIT_STATUS_DATE"],
      engTime: json["ENG_TIME"],
      callStatus: json["CALL_STATUS"],
      borrowerName: json["BORROWER_NAME"],
      contactPerson: json["CONTACT_PERSON"],
      mobileNo1: json["MOBILE_NO_1"],
      mobileNo2: json["MOBILE_NO_2"],
      mobileNo3: json["MOBILE_NO_3"],
      landlineNo1: json["LANDLINE_NO_1"],
      landlineNo2: json["LANDLINE_NO_2"],
      loanType: json["LOAN_TYPE"],
      legalDocument: json["LEGAL_DOCUMENT"],
      visitAllocated: json["VISIT_ALLOCATED"],
      visitAllocatedName: json["VISIT_ALLOCATED_NAME"],
      propertyAddress: json["PROPERTY_ADDRESS"],
      caseStatus: json["CASE_STATUS"],
      flatNo: json["FLAT_NO"],
      floorWing: json["FLOOR_WING"],
      societyBuilding: json["SOCIETY_BUILDING"],
      plotNo: json["PLOT_NO"],
      sectorColony: json["SECTOR_COLONY"],
      roadArea: json["ROAD_AREA"],
      location: json["LOCATION"],
      locationName: json["LOCATION_NAME"],
      ctsSurveyVillage: json["CTS_SURVEY_VILLAGE"],
      district: json["DISTRICT"],
      splInstruction: json["SPL_INSTRUCTION"],
      pinCode: json["PIN_CODE"],
      createdDate: DateTime.tryParse(json["CREATED_DATE"] ?? ""),
      createdBy: json["CREATED_BY"],
      modifiedDate: json["MODIFIED_DATE"],
      modifiedBy: json["MODIFIED_BY"],
      priorityFlag: json["PRIORITY_FLAG"],
      appSubmitStatus: json["APP_SUBMIT_STATUS"],
      orderCondition: json["ORDER_CONDITION"],
      casNo: json["CAS_NO"],
      copyFlag: json["COPY_FLAG"],
      oldCase: json["OLD_CASE"],
    );
  }
}
