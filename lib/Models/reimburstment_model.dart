class ReimburstmentModel {
  dynamic reqId;
  dynamic reqDate;
  dynamic currStatus;
  dynamic approveFlag;
  dynamic totalClaim;
  dynamic name;
  dynamic userCode;
  dynamic newStatus;

  ReimburstmentModel({
    this.reqId,
    this.reqDate,
    this.currStatus,
    this.approveFlag,
    this.totalClaim,
    this.name,
    this.userCode,
    this.newStatus,
  });

  factory ReimburstmentModel.fromJson(Map<String, dynamic> json) {
    return ReimburstmentModel(
      reqId: json['REQ_ID'],
      reqDate: json['REQ_DATE'],
      currStatus: json['CURR_STATUS'],
      approveFlag: json['APPROVE_FLAG'],
      totalClaim: json['TOTAL_CLAIM'],
      name: json['NAME'],
      userCode: json['USER_CODE'],
      newStatus: json['NEW_STATUS'],
    );
  }
}
