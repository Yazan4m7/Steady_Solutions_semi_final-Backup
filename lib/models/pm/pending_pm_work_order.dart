class PendingPMWorkOrder {
  int? jobNO;
  String? dateOfJob;
  String? controlNo;
  String? equipName;
  String? categoryName;
  String? siteName;
  String? cMPM;
  int? type;
  int? companyID;
  String? reportID;
  String? statusDesc2;
  String? reasonForNotClosingJob;

  PendingPMWorkOrder(
      {this.jobNO,
      this.dateOfJob,
      this.controlNo,
      this.equipName,
      this.categoryName,
      this.siteName,
      this.cMPM,
      this.type,
      this.companyID,
      this.reportID,
      this.statusDesc2,
      this.reasonForNotClosingJob});

  PendingPMWorkOrder.fromJson(Map<String, dynamic> json) {
    jobNO = json['JobNO'];
    dateOfJob = json['DateOfJob'];
    controlNo = json['ControlNo'];
    equipName = json['EquipName'];
    categoryName = json['CategoryName'];
    siteName = json['SiteName'];
    cMPM = json['CMPM'];
    type = json['Type'];
    companyID = json['CompanyID'];
    reportID = json['ReportID'].toString() == '0' ? "Incomplete" : json['ReportID'].toString();
    statusDesc2 = json['StatusDesc2'] ?? "None";
    reasonForNotClosingJob = json['ReasonForNotClosingJob'] ?? "None";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobNO'] = this.jobNO;
    data['DateOfJob'] = this.dateOfJob;
    data['ControlNo'] = this.controlNo;
    data['EquipName'] = this.equipName;
    data['CategoryName'] = this.categoryName;
    data['SiteName'] = this.siteName;
    data['CMPM'] = this.cMPM;
    data['Type'] = this.type;
    data['CompanyID'] = this.companyID;
    data['ReportID'] = this.reportID;
    data['StatusDesc2'] = this.statusDesc2;
    data['ReasonForNotClosingJob'] = this.reasonForNotClosingJob;
    return data;
  }
}