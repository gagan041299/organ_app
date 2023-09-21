class DashboardCountModel {
  DashboardCountModel({
    required this.userCode,
    required this.firstName,
    required this.lastName,
    required this.allocationMonth,
    required this.workdoneMonth,
    required this.todayfreshAllocation,
    required this.totalvistForday,
    required this.todayvisitDone,
    required this.tomorrowAllocation,
    required this.spillCases,
  });

  final String? userCode;
  final String? firstName;
  final String? lastName;
  final int? allocationMonth;
  final int? workdoneMonth;
  final int? todayfreshAllocation;
  final int? totalvistForday;
  final int? todayvisitDone;
  final int? tomorrowAllocation;
  final int? spillCases;

  factory DashboardCountModel.fromJson(Map<String, dynamic> json) {
    return DashboardCountModel(
      userCode: json["USER_CODE"],
      firstName: json["FIRST_NAME"],
      lastName: json["LAST_NAME"],
      allocationMonth: json["ALLOCATION_MONTH"],
      workdoneMonth: json["WORKDONE_MONTH"],
      todayfreshAllocation: json["TODAYFRESH_ALLOCATION"],
      totalvistForday: json["TOTALVIST_FORDAY"],
      todayvisitDone: json["TODAYVISIT_DONE"],
      tomorrowAllocation: json["TOMORROW_ALLOCATION"],
      spillCases: json["SPILL_CASES"],
    );
  }
}
