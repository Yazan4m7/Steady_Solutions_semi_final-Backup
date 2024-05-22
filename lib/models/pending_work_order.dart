class PendingWorkOrder {
  String? jobNumber;
  String? departmentDesc;
  String? controlNumber;
  String? failureDateTime;
  String? statusDesc;
  String? isUrgent;
  String? priority;
  String? equipmentID;
  String? equipmentTypeID;
  String? companyID;
  String? type;

  // Generate constructor
  PendingWorkOrder({
    this.jobNumber,
    this.departmentDesc,
    this.controlNumber,
    this.failureDateTime,
    this.statusDesc,
    this.isUrgent,
    this.priority,
    this.equipmentID,
    this.equipmentTypeID,
    this.companyID,
    this.type,
  });

  // ToJson function
  Map<String, dynamic> toJson() {
    return {
      'JobNO': jobNumber,
      'DepartmentDesc': departmentDesc,
      'ControlNO': controlNumber,
      'FailureDateTime': failureDateTime,
      'StatusDesc': statusDesc,
      'IsUrgent': isUrgent,
      'priority': priority ?? '0',
      'equipmentID': equipmentID,
      'EquipmentTypeID': equipmentTypeID,
      'CompanyID': companyID,
      'Type': type,
    };
  }

  //fromJson function
  factory PendingWorkOrder.fromJson(Map<String, dynamic> json) {
    return PendingWorkOrder(
      jobNumber: json['JobNO'].toString(),
      departmentDesc: json['DepartmentDesc'].toString(),
      controlNumber: json['ControlNO'].toString(),
      failureDateTime: json['FailureDateTime'].toString(),
      statusDesc: json['StatusDesc'].toString(),
      isUrgent: json['IsUrgent'].toString(),
      priority: json['priority'] ?? '0',
      equipmentID: json['equipmentID'].toString(),
      equipmentTypeID: json['EquipmentTypeID'].toString(),
      companyID: json['CompanyID'].toString(),
      type: json['Type'].toString(),
    );
  }
}
