
  class ControlItem {
    String? equipName;
    String? serNO;
    String? id;
    String? controlNo;
    bool? havePendingWO;
    String? serviceDesc;

    ControlItem({this.equipName, this.serNO, this.id, this.controlNo, this.havePendingWO, this.serviceDesc});

    factory ControlItem.fromJson(Map<String, dynamic> json) {
      return ControlItem(
        equipName: json['EquipName'].toString(),
        serNO: json['SerNO'].toString(),
        id: json['ID'].toString(),
        controlNo: json['ControlNo'].toString(),
        havePendingWO: json['HavePendingWO'],
 serviceDesc: json['ServiceDesc'],
          
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'EquipName': this.equipName,
        'SerNO': this.serNO,
        'ID': this.id,
        'ControlNo': this.controlNo,
        'HavePendingWO': this.havePendingWO,
        'ServiceDesc' : serviceDesc
      };
    }
  }
