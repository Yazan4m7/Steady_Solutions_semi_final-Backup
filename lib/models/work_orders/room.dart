class Room {
  String? id;
  String? name;
  String? deptId;

  Room({this.id, this.name, this.deptId});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['RoomID'].toString() ;
    name = json['RoomName'].toString() ;
    deptId = json['DepartmentID'].toString() ;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RoomID'] = this.id;
    data['RoomName'] = this.name;
    data['DepartmentID'] = this.deptId;
    return data;
  }
}
