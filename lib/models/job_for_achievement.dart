class ControlItemFromAchievement {
  String? controlNumber;
  String? equipName;
  String? failureDate;
  String? caller;
  String? faultStatus;

  ControlItemFromAchievement(
      {this.controlNumber,
      this.equipName,
      this.failureDate,
      this.caller,
      this.faultStatus});

  factory ControlItemFromAchievement.fromJson(Map<String, dynamic> json) {
    return ControlItemFromAchievement(
      controlNumber: (json['ControlNo'] == "" || json['ControlNo'] == null)
          ? "Not available"
          : json['ControlNo'],
      equipName: (json['EquipName'] == "" || json['EquipName'] == null)
          ? "Not available"
          : json['EquipName'],
      failureDate:
          (json['FailureDateTime'] == "" || json['FailureDateTime'] == null)
              ? "Not available"
              : json['FailureDateTime'],
      caller: (json['CallerName'] == "" || json['CallerName'] == null)
          ? "Not available"
          : json['CallerName'],
      faultStatus: (json['FaultStatus'] == "" || json['FaultStatus'] == null)
          ? "Not available"
          : json['FaultStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ControlNo': this.controlNumber,
      'EquipName': this.equipName,
      'FailureDate': this.failureDate,
      'Caller': this.caller,
      'FaultStatus': this.faultStatus,
    };
  }
}
