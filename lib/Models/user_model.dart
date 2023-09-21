class UserModel {
  UserModel({
    required this.id,
    required this.userCode,
    required this.firstName,
    required this.lastName,
    required this.userStatus,
    required this.userDesignation,
    required this.activeDate,
    required this.closeDate,
    required this.remarks,
    required this.userType,
    required this.email,
    required this.address,
    required this.mobileNo,
    required this.password,
    required this.roleCode,
    required this.mapFlag,
    required this.branchName,
    required this.appVersion,
    required this.reportingTo,
    required this.empLimit,
    required this.casesLimit,
    required this.rememberToken,
    required this.createdBy,
    required this.modifiedBy,
  });

  final int? id;
  final String? userCode;
  final String? firstName;
  final String? lastName;
  final String? userStatus;
  final String? userDesignation;
  final DateTime? activeDate;
  final DateTime? closeDate;
  final String? remarks;
  final String? userType;
  final String? email;
  final String? address;
  final String? mobileNo;
  final String? password;
  final String? roleCode;
  final String? mapFlag;
  final String? branchName;
  final String? appVersion;
  final String? reportingTo;
  final String? empLimit;
  final int? casesLimit;
  final String? rememberToken;
  final String? createdBy;
  final DateTime? modifiedBy;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      userCode: json["user_code"],
      firstName: json["FIRST_NAME"],
      lastName: json["LAST_NAME"],
      userStatus: json["USER_STATUS"],
      userDesignation: json["USER_DESIGNATION"],
      activeDate: DateTime.tryParse(json["ACTIVE_DATE"] ?? ""),
      closeDate: DateTime.tryParse(json["CLOSE_DATE"] ?? ""),
      remarks: json["REMARKS"],
      userType: json["USER_TYPE"],
      email: json["email"],
      address: json["ADDRESS"],
      mobileNo: json["MOBILE_NO"],
      password: json["password"],
      roleCode: json["ROLE_CODE"],
      mapFlag: json["MAP_FLAG"],
      branchName: json["BRANCH_NAME"],
      appVersion: json["APP_VERSION"],
      reportingTo: json["REPORTING_TO"],
      empLimit: json["EMP_LIMIT"],
      casesLimit: json["CASES_LIMIT"],
      rememberToken: json["remember_token"],
      createdBy: json["CREATED_BY"],
      modifiedBy: DateTime.tryParse(json["MODIFIED_BY"] ?? ""),
    );
  }
}
