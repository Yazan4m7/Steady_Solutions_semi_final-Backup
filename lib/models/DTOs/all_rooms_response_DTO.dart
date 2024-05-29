class AllRoomsResponseDTO {
  bool? disabled;
  Group? group;
  bool? selected;
  String? text;
  String? value;

  AllRoomsResponseDTO(
      {this.disabled, this.group, this.selected, this.text, this.value});

  AllRoomsResponseDTO.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    group = json['Group'] != null ? new Group.fromJson(json['Group']) : null;
    selected = json['Selected'];
    text = json['Text'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Disabled'] = this.disabled;
    if (this.group != null) {
      data['Group'] = this.group!.toJson();
    }
    data['Selected'] = this.selected;
    data['Text'] = this.text;
    data['Value'] = this.value;
    return data;
  }
}

class Group {
  bool? disabled;
  String? name;

  Group({this.disabled, this.name});

  Group.fromJson(Map<String, dynamic> json) {
    disabled = json['Disabled'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Disabled'] = this.disabled;
    data['Name'] = this.name;
    return data;
  }
}
