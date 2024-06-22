class AchievementReport {
  int? cMReportID;
  int? jobNO;
  int? equipID;
  String? equipName;
  String? failureDateTime;
  String? callerName;
  String? faultStatus;
  String? remedy;
  String? reasonForNotClosingJob;
  String? actionTakenToClosePendingJob;
  String? travelTime;
  String? repairDate;
  String? startDate;
  String? endDate;

  AchievementReport(
      {this.cMReportID,
      this.jobNO,
      this.equipID,
      this.equipName,
      this.failureDateTime,
      this.callerName,
      this.faultStatus,
      this.remedy,
      this.reasonForNotClosingJob,
      this.actionTakenToClosePendingJob,
      this.travelTime,
      this.repairDate,
      this.startDate,
      this.endDate});

  AchievementReport.fromJson(Map<String, dynamic> json) {
    cMReportID = json['CMReportID'] ?? "N/A";
    jobNO = json['JobNO']?? "N/A";
    equipID = json['EquipID']?? "N/A";
    equipName = json['EquipName']?? "N/A";
    failureDateTime = json['FailureDateTime']?? "N/A";
    callerName = json['CallerName']?? "N/A";
    faultStatus = json['FaultStatus']?? "N/A";
    remedy = json['Remedy']?? "N/A";
    reasonForNotClosingJob = json['ReasonForNotClosingJob']?? "N/A";
    actionTakenToClosePendingJob = json['ActionTakenToClosePendingJob']?? "N/A";
    travelTime = json['TravelTime']?? "N/A";
    repairDate = json['RepairDate']?? "N/A";
    startDate = json['StartDate']?? "N/A";
    endDate = json['EndDate']?? "N/A";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CMReportID'] = this.cMReportID;
    data['JobNO'] = this.jobNO;
    data['EquipID'] = this.equipID;
    data['EquipName'] = this.equipName;
    data['FailureDateTime'] = this.failureDateTime;
    data['CallerName'] = this.callerName;
    data['FaultStatus'] = this.faultStatus;
    data['Remedy'] = this.remedy;
    data['ReasonForNotClosingJob'] = this.reasonForNotClosingJob;
    data['ActionTakenToClosePendingJob'] = this.actionTakenToClosePendingJob;
    data['TravelTime'] = this.travelTime;
    data['RepairDate'] = this.repairDate;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    return data;
  }
}