class WorkOrderDetails {
  String? controlNo;
  String? equipName;
  String? failureDateTime;
  String? callerName;
  String? faultStatus;

  WorkOrderDetails(
      {this.controlNo,
      this.equipName,
      this.failureDateTime,
      this.callerName,
      this.faultStatus});

  WorkOrderDetails.fromJson(Map<String, dynamic> json) {
    controlNo = json['ControlNo'];
    equipName = json['EquipName'];
    failureDateTime = json['FailureDateTime'];
    callerName = json['CallerName'];
    faultStatus = json['FaultStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ControlNo'] = this.controlNo;
    data['EquipName'] = this.equipName;
    data['FailureDateTime'] = this.failureDateTime;
    data['CallerName'] = this.callerName;
    data['FaultStatus'] = this.faultStatus;
    return data;
  }
}