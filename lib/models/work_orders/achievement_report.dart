class AchievementReport {
  String? cMReportID;
  String? jobNO;
  String? equipID;
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
  String? comments;
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
      this.endDate,
      this.comments});

  AchievementReport.fromJson(Map<String, dynamic> json) {
    cMReportID = json['CMReportID'].toString();
    jobNO = json['JobNO'].toString();
    equipID = json['EquipID'].toString();
    equipName = json['EquipName'].toString();
    failureDateTime = json['FailureDateTime'].toString();
    callerName = json['CallerName'].toString();
    faultStatus = json['FaultStatus'].toString();
    remedy = json['Remedy'].toString();
    reasonForNotClosingJob = json['ReasonForNotClosingJob'].toString();
    actionTakenToClosePendingJob =
        json['ActionTakenToClosePendingJob'].toString();
    travelTime = json['TravelTime'].toString();
    repairDate = json['RepairDate'].toString();
    startDate = json['StartDate'].toString();
    endDate = json['EndDate'].toString();
    comments = json['Comments'].toString();
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
    data['Comments'] = this.comments;
    return data;
  }
}
