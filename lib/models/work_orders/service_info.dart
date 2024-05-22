class ServiceInfo {
  String? Id;
  String? controlNo;
  String? serviceDesc;

  ServiceInfo({this.Id, this.controlNo, this.serviceDesc});

  ServiceInfo.fromJson(Map<String, dynamic> json) {
    Id = json['ID'].toString();
    controlNo = json['ControlNo'].toString();
    serviceDesc = json['ServiceDesc'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.Id;
    data['ControlNo'] = this.controlNo;
    data['ServiceDesc'] = this.serviceDesc;
    return data;
  }
}
